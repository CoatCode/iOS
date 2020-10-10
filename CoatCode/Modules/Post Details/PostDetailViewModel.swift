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
    let comment = BehaviorRelay<[Comment]>(value: [Comment(id: -1, owner: User(), content: "", createdAt: Date())])
    
    let commentText = BehaviorRelay(value: "")
    
    init(with post: Post) {
        self.post = BehaviorRelay(value: post)
    }
    
    struct Input {
        let sendButtonTrigger: Driver<Void>
    }
    
    struct Output {
        let items: Observable<[PostDetailSection]>
    }
    
}

extension PostDetailViewModel {
    func transform(input: Input) -> Output {
        
        input.sendButtonTrigger
            .drive(onNext: { [weak self] in
                self?.writeCommentRequest()
            }).disposed(by: disposeBag)
        
        let items = post.map { post -> [PostDetailSection] in
            var items: [PostDetailSectionItem] = []
            
            // Post
            let postDetailCellViewModel = PostDetailCellViewModel(with: self.post.value)
            items.append(PostDetailSectionItem.postDetailItem(viewModel: postDetailCellViewModel))
            
            // Comment
            self.services.postComments(postId: post.id)
                .trackActivity(self.loading)
                .subscribe(onNext: { [weak self] comment in
                    self?.comment.accept(comment)
                }).disposed(by: self.disposeBag)
            
            let comments = self.comment.value.map { CommentCellViewModel(with: $0) }
            comments.forEach { (cellViewModel) in
                items.append(PostDetailSectionItem.commentItem(viewModel: cellViewModel))
            }
            
            return [PostDetailSection.post(title: "", items: items)] 
        }
        
        return Output(items: items)
    }
}

extension PostDetailViewModel {
    
    func writeCommentRequest() {
        self.services.writeComment(postId: self.post.value.id, content: self.commentText.value)
            .trackActivity(self.loading)
            .subscribe(onNext: {
                print("write comment successfully")
            }, onError: { [weak self] error in
                self?.error.onNext(error as! ErrorResponse)
            }).disposed(by: disposeBag)
    }
    
}
