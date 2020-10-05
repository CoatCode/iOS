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
    let contentImageUrl = BehaviorRelay<URL?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let likeCount = BehaviorRelay<Int?>(value: nil)
    let commentCount = BehaviorRelay<Int?>(value: nil)
    let viewCount = BehaviorRelay<Int?>(value: nil)
    let isLiked = BehaviorRelay<Bool?>(value: nil)
    
    let post: Post
    
    init(with post: Post) {
        self.post = post
        
        profileName.accept(post.owner.username)
        profileImageUrl.accept(post.owner.profile)
        contentImageUrl.accept(post.imageURLs?.first)
        content.accept(post.content)
        likeCount.accept(post.likeCount)
        commentCount.accept(post.commentCount)
        viewCount.accept(post.viewCount)
        
        // 좋아요 여부
        guard let isLiked = post.likedPeoples?.contains(DatabaseManager.shared.getCurrentUser().id) else { return }
        
        if isLiked {
            self.isLiked.accept(true)
        } else {
            self.isLiked.accept(false)
        }
    }
}
