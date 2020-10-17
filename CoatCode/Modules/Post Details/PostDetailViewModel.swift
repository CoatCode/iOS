//
//  PostDetailViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class PostDetailViewModel: BaseViewModel {
    
    let post: BehaviorRelay<Post>
    let comments = PublishSubject<[Comment]>()
    let commentText = BehaviorRelay(value: "")
    
    init(with post: Post) {
        self.post = BehaviorRelay(value: post)
    }
    
    struct Input {
        let sendButtonTrigger: Driver<Void>
    }
    
    struct Output {
        let items: Observable<[PostDetailSection]>
        let sendButtonEnabled: Driver<Bool>
    }
    
}

extension PostDetailViewModel {
    func transform(input: Input) -> Output {
        
        input.sendButtonTrigger
            .drive(onNext: { [weak self] in
                self?.writeCommentRequest()
            }).disposed(by: disposeBag)
        
        
        post.subscribe(onNext: { [weak self] _ in
            self?.getCommentsRequest()
        }).disposed(by: disposeBag)
        
        
//        post.flatMapLatest { [weak self] post -> Observable<[Comment]> in
//            guard let self = self else { return Observable.just([]) }
//            return self.services.postComments(postId: post.id)
//                .trackActivity(self.loading)
//        }.subscribe(onNext: { [weak self] comments in
//            self?.comments.onNext(comments)
//        }).disposed(by: disposeBag)
        
        let items = comments.map { comments -> [PostDetailSection] in
            var items: [PostDetailSectionItem] = []
            
            let postDetailCellViewModel = PostDetailCellViewModel(post: self.post.value, services: self.services)
            items.append(PostDetailSectionItem.postDetailItem(viewModel: postDetailCellViewModel))
            
            let commentCellViewModels = comments.map { CommentCellViewModel(with: $0) }
            commentCellViewModels.forEach { (cellViewModel) in
                items.append(PostDetailSectionItem.commentItem(viewModel: cellViewModel))
            }
            
            return [PostDetailSection.post(title: "", items: items)]
        }
        
        let sendButtonEnabled = BehaviorRelay.combineLatest(self.commentText, self.loading.asObservable()) {
            return !$0.isEmpty && !$1
        }.asDriver(onErrorJustReturn: false)
        
        return Output(items: items, sendButtonEnabled: sendButtonEnabled)
    }
}

extension PostDetailViewModel {
    
    func writeCommentRequest() {
        self.services.writeComment(postId: self.post.value.id, content: self.commentText.value)
            .trackActivity(self.loading)
            .subscribe(onNext: { [weak self] in
                print("write comment successfully")
                self?.getCommentsRequest()
            }, onError: { [weak self] error in
                self?.error.onNext(error as! ErrorResponse)
            }).disposed(by: disposeBag)
    }
    
    func getCommentsRequest() {
        self.services.postComments(postId: self.post.value.id)
            .trackActivity(self.loading)
            .subscribe(onNext: { [weak self] comments in
                self?.comments.onNext(comments)
            }).disposed(by: disposeBag)
    }
}
