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
        let selection: Driver<FeedCellViewModel>
    }
    
    struct Output{
        let items: BehaviorRelay<[FeedCellViewModel]>
    }
    
    let filter = BehaviorRelay(value: FeedFilter.allContent)
    
}

// MARK: - Transform
extension FeedViewModel {
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[FeedCellViewModel]>(value: [])
        
        // Header Refresh
        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[FeedCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.loading)
        }).subscribe(onNext: { items in
            elements.accept(items)
        }).disposed(by: disposeBag)
        
        // Footer Refresh
        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[FeedCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.loading)
        }).subscribe(onNext: { items in
            elements.accept(elements.value + items)
        }).disposed(by: disposeBag)
        
        // 선택된 게시물의 내용을 상세보기 화면으로 넘겨줌
        input.selection
            .drive(onNext: { [weak self] cellViewModel in
                self?.steps.accept(CoatCodeStep.postDetailIsRequired(post: cellViewModel.post))
            }).disposed(by: disposeBag)
        
        return Output(items: elements)
    }
    
    // 필터에 따른 게시물 요청
    func request() -> Observable<[FeedCellViewModel]> {
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
            .map { $0.map { FeedCellViewModel(with: $0) } }
    }
    
}
