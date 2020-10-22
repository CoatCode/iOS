//
//  FeedViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/20.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

enum FeedFilter {
    case allContent
    case followContent
    case popularContent
}

class FeedViewModel: BaseViewModel {
    
    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let selection: Driver<FeedSectionItem>
    }
    
    struct Output {
        let items: Observable<[FeedSection]>
    }
    
    let filter = BehaviorRelay(value: FeedFilter.allContent)
    
}

// MARK: - Transform
extension FeedViewModel {
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[FeedSection]>(value: [])
        
        // Header Refresh
        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[Post]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.loading)
        }).subscribe(onNext: { posts in
            var sections: [FeedSection] = []
            
            posts.forEach { (post) in
                var items: [FeedSectionItem] = []
                let postCellViewModel = PostCellViewModel(post: post, services: self.services)
                items.append(FeedSectionItem.postItem(viewModel: postCellViewModel))
                
                post.commentPreview?.forEach { (comment) in
                    items.append(FeedSectionItem.commentPreviewItem(viewModel: CommentPreviewCellViewModel(comment: comment)))
                }
                sections.append(FeedSection.feed(title: "", items: items))
            }
            
            elements.accept(sections)
        }).disposed(by: disposeBag)
        
        // Footer Refresh
        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[Post]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.loading)
        }).subscribe(onNext: { posts in
            var items: [FeedSectionItem] = []
            
            posts.forEach { (post) in
                let postCellViewModel = PostCellViewModel(post: post, services: self.services)
                items.append(FeedSectionItem.postItem(viewModel: postCellViewModel))
                
                post.commentPreview?.forEach { (comment) in
                    items.append(FeedSectionItem.commentPreviewItem(viewModel: CommentPreviewCellViewModel(comment: comment)))
                }
            }
            
            elements.accept(elements.value + [FeedSection.feed(title: "", items: items)])
        }).disposed(by: disposeBag)
        
        // 선택된 게시물의 내용을 상세보기 화면으로 넘겨줌
        input.selection
            .drive(onNext: { [weak self] sectionItem in
                switch sectionItem {
                case .postItem(let viewModel):
                    self?.steps.accept(CoatCodeStep.postDetailIsRequired(cellViewModel: viewModel))
                case .commentPreviewItem(let viewModel):
                    print("comment preview cell seleceted.")
                }
            }).disposed(by: disposeBag)
        
        return Output(items: elements.asObservable())
    }
    
    // 필터에 따른 게시물 요청
    func request() -> Observable<[Post]> {
        var request: Single<[Post]>
        
        switch self.filter.value {
        case .allContent:
            request = self.services.allFeedPosts(page: self.page)
        case .followContent:
            request = self.services.followFeedPosts(page: self.page)
        case .popularContent:
            request = self.services.popularFeedPosts(page: self.page)
        }
        
        return request
            .trackActivity(loading)
        //            .map { $0.map { PostCellViewModel(post: $0, services: self.services) } }
    }
    
}
