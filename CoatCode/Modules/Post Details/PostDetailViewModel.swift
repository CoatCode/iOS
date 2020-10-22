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
    
    let cellViewModel: BehaviorRelay<PostCellViewModel>
    let comments = PublishSubject<[Comment]>()
    let commentText = BehaviorRelay(value: "")
    
    init(with cellViewModel: PostCellViewModel) {
        self.cellViewModel = BehaviorRelay(value: cellViewModel)
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
        
        cellViewModel.subscribe(onNext: { [weak self] cellViewModel in
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
            
            // 게시물 viewModel
            let postCellViewModel = self.cellViewModel
            items.append(PostDetailSectionItem.postDetailItem(viewModel: postCellViewModel.value))
            
            // 댓글 viewModel
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
        self.services.writeComment(postId: self.cellViewModel.value.post.id, content: self.commentText.value)
            .trackActivity(self.loading)
            .subscribe(onNext: { [weak self] in
                print("write comment successfully")
                self?.getCommentsRequest()
            }, onError: { [weak self] error in
                self?.error.onNext(error as! ErrorResponse)
            }).disposed(by: disposeBag)
    }
    
    func getCommentsRequest() {
        self.services.postComments(postId: self.cellViewModel.value.post.id)
            .trackActivity(self.loading)
            .subscribe(onNext: { [weak self] comments in
                self?.comments.onNext(comments)
            }).disposed(by: disposeBag)
    }
    
    func editComment() {
        
    }
    
    func deleteComment(commentId: Int) {
        self.services.deleteComment(postId: self.cellViewModel.value.post.id, commentId: commentId)
            .trackActivity(self.loading)
            .subscribe(onNext: {
                
            }).disposed(by: disposeBag)
    }
}
