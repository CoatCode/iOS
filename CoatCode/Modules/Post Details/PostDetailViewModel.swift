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
    
    init(with post: Post) {
        self.post = BehaviorRelay(value: post)
    }
    
    struct Input {
        
    }
    
    struct Output {
        let items: Observable<[PostDetailSection]>
    }
    
}

extension PostDetailViewModel {
    func transform(input: Input) -> Output {
        
        let items = post.map { post -> [PostDetailSection] in
            var items: [PostDetailSectionItem] = []
            
            // Post
            let postDetailCellViewModel = PostDetailCellViewModel(with: self.post.value)
            items.append(PostDetailSectionItem.postDetailItem(viewModel: postDetailCellViewModel))
            
            // Comment
            self.services.feedComments(postId: post.id)
                .trackActivity(self.loading)
                .subscribe(onNext: { [weak self] comment in
                    self?.comment.accept(comment)
                }).disposed(by: self.disposeBag)
            
//            if let comments = self.comment.value.map({ CommentCellViewModel(with: $0) }) {
//                comments.forEach({ (cellViewModel) in
//                    items.append(PostDetailSectionItem.commentItem(viewModel: cellViewModel))
//                })
//            }
            
            let comments = self.comment.value.map { CommentCellViewModel(with: $0) }
            comments.forEach { (cellViewModel) in
                items.append(PostDetailSectionItem.commentItem(viewModel: cellViewModel))
            }
            
            return [PostDetailSection.post(title: "", items: items)] 
        }
        
        return Output(items: items)
    }
}
