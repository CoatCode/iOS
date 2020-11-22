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

    let comments = PublishSubject<[Comment]>()
    let commentText = BehaviorRelay(value: "")
    
    let commentMore = PublishSubject<Comment>()
    
    let cellViewModel: BehaviorRelay<PostCellViewModel>

    init(with cellViewModel: PostCellViewModel) {
        self.cellViewModel = BehaviorRelay(value: cellViewModel)
    }

    struct Input {
        let sendButtonTrigger: Observable<Void>
        let profileTrigger: Driver<Void>
        let deleteComment: Observable<Comment>
        let reportComment: Observable<Comment>
    }

    struct Output {
        let items: Observable<[PostDetailSection]>
        let sendButtonEnabled: Driver<Bool>
        let commentMoreSelected: Driver<Comment>
        let dismissKeyboard: Driver<Void>
    }
}

extension PostDetailViewModel {
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[PostDetailSection]>(value: [])
        let sendComplete = PublishSubject<Void>()
        
        input.profileTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let user = self.cellViewModel.value.post.owner
                self.steps.accept(CoatCodeStep.profileIsRequired(user: user))
            }).disposed(by: disposeBag)
        
        let sendComment = input.sendButtonTrigger.flatMapLatest { [weak self] () -> Observable<Void> in
            guard let self = self else { return Observable.just(()) }
            let postId = self.cellViewModel.value.post.id
            let commentContent = self.commentText.value
            return self.services.writeComment(postId: postId, content: commentContent)
                .trackActivity(self.loading)
        }.share()
        
        let deleteComment = input.deleteComment.flatMapLatest { [weak self] (comment) -> Observable<Void> in
            guard let self = self else { return Observable.just(()) }
            guard let commentId = comment.id else { return Observable.just(()) }
            let postId = self.cellViewModel.value.post.id
            return self.services.deleteComment(postId: postId, commentId: commentId)
                .trackActivity(self.loading)
        }
        
        // 댓글 신고 후 refresh
//        let reportComment = self.reportComment.flatMapLatest { [weak self] (comment) -> Observable<Void> in
//            guard let self = self else { return Observable.just(()) }
//        }
        
        sendComment.bind(to: sendComplete).disposed(by: disposeBag)
        
        let refresh = Observable.of(Observable.just(()), sendComment, deleteComment).merge()
        
        refresh.flatMapLatest { [weak self] () -> Observable<[CommentCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            let postId = self.cellViewModel.value.post.id
            return self.services.postComments(postId: postId)
                .trackActivity(self.loading)
                .map { $0.map({ (comment) -> CommentCellViewModel in
                    let viewModel = CommentCellViewModel(with: comment)
                    viewModel.commentMore.bind(to: self.commentMore).disposed(by: self.disposeBag)
                    return viewModel
                })}
        }.subscribe(onNext: { (commentCellViewModels) in
            var items: [PostDetailSectionItem] = []
            // 게시물 viewModel
            items.append(.postDetailItem(viewModel: self.cellViewModel.value))
            
            // 댓글 viewModel
            commentCellViewModels.forEach { (viewModel) in
                items.append(.commentItem(viewModel: viewModel))
            }
            elements.accept([PostDetailSection.post(title: "", items: items)])
        }).disposed(by: disposeBag)

        let sendButtonEnabled = BehaviorRelay.combineLatest(self.commentText, self.loading.asObservable()) {
            return !$0.isEmpty && !$1
        }.asDriver(onErrorJustReturn: false)

        return Output(items: elements.asObservable(),
                      sendButtonEnabled: sendButtonEnabled,
                      commentMoreSelected: commentMore.asDriver(onErrorJustReturn: Comment()),
                      dismissKeyboard: sendComplete.asDriver(onErrorJustReturn: ()))
    }
}

extension PostDetailViewModel {
    func editPost(_ post: Post) {
//        self.steps.accept(CoatCodeStep.editPostIsRequired(post))
    }

    func deletePost(_ postId: Int) {
        self.services.deletePost(postId: postId)
            .trackActivity(self.loading)
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(CoatCodeStep.popViewIsRequired)
            }).disposed(by: disposeBag)
    }

    func reportPost(_ postId: Int) {
        print("report post \(postId)")
    }
}
