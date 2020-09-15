//
//  FeedCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/15.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class FeedCellViewModel {
    
    let profileName = BehaviorRelay<String?>(value: nil)
    let profileImageUrl = BehaviorRelay<String?>(value: nil)
    let contentImageUrl = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let likeCount = BehaviorRelay<Int?>(value: nil)
    let commentCount = BehaviorRelay<Int?>(value: nil)
    let viewCount = BehaviorRelay<Int?>(value: nil)
    
    let post: Post
    
    init(with post: Post) {
        self.post = post
        
//        profileName.accept(post.owner.name)
//        profileImageUrl.accept(post.owner.profileImage)
        contentImageUrl.accept(post.contentImages.first!)
        content.accept(post.content)
        likeCount.accept(post.likeCount)
        commentCount.accept(post.commentCount)
        viewCount.accept(post.viewCount)
        
    }
    
    
    
}
