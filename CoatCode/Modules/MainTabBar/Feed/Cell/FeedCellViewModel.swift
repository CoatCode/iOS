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
    let title = BehaviorRelay<String?>(value: nil)
    let likeCount = BehaviorRelay<Int?>(value: nil)
    let commentCount = BehaviorRelay<Int?>(value: nil)
    let viewCount = BehaviorRelay<Int?>(value: nil)
    let isLiked = BehaviorRelay<Bool?>(value: nil)
    let createdTime = BehaviorRelay<Date?>(value: nil)
    
    let disposeBag = DisposeBag()
    var services: CoatCodeService
    var post: Post
    
    init(post: Post, services: CoatCodeService) {
        self.post = post
        self.services = services
        
        self.profileName.accept(post.owner.username)
        self.profileImageUrl.accept(post.owner.profile)
        self.contentImageUrl.accept(post.imageURLs?.first)
        self.title.accept(post.title)
        self.likeCount.accept(post.likeCount)
        self.commentCount.accept(post.commentCount)
        self.viewCount.accept(post.viewCount)
        self.createdTime.accept(post.createdAt)
        
        // 좋아요 여부
        if let isLiked = post.likedPeoples?.contains(DatabaseManager.shared.getCurrentUser().id) {
            self.isLiked.accept(isLiked)
        } else {
            self.isLiked.accept(false)
        }
    }
    
    func like() {
        self.services.likePost(postId: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLiked.accept(true)
                self.likeCount.accept((self.likeCount.value ?? 0) + 1)
                self.post.likeCount = (self.likeCount.value ?? 0) + 1
            }, onError: { [weak self] error in
                self?.unLike()
            }).disposed(by: disposeBag)
    }
    
    func unLike() {
        self.services.unlikePost(postId: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isLiked.accept(false)
                self.likeCount.accept((self.likeCount.value ?? 0) - 1)
                self.post.likeCount = (self.likeCount.value ?? 0) - 1
            }, onError: { [weak self] error in
                self?.like()
            }).disposed(by: disposeBag)
    }
}
