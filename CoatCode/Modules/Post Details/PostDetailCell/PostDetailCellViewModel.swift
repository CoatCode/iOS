//
//  PostDetailCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/23.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PostDetailCellViewModel {
    
    let contentImageUrls = BehaviorRelay<[URL]?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let likeCount = BehaviorRelay<Int?>(value: nil)
    let commentCount = BehaviorRelay<Int?>(value: nil)
    let viewCount = BehaviorRelay<Int?>(value: nil)
    let isLiked = BehaviorRelay<Bool?>(value: nil)
    let tag = BehaviorRelay<String?>(value: nil)
    let createdTime = BehaviorRelay<Date?>(value: nil)
    
    let post: Post
    
    init(with post: Post) {
        self.post = post
        
        self.contentImageUrls.accept(post.imageURLs)
        self.title.accept(post.title)
        self.content.accept(post.content)
        self.likeCount.accept(post.likeCount)
        self.commentCount.accept(post.commentCount)
        self.viewCount.accept(post.viewCount)
        self.isLiked.accept(post.isLiked)
        self.tag.accept(post.tag)
        self.createdTime.accept(post.createdAt)
    }
}
