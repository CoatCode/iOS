//
//  PostCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/18.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

class PostCellViewModel {

    // writer profile
    let username = BehaviorRelay<String?>(value: nil)
    let profileImageUrl = BehaviorRelay<String?>(value: nil)

    // Post Content
    let imageUrls = BehaviorRelay<[URL]?>(value: nil)
    let title = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)

    let likeCount = BehaviorRelay<Int?>(value: nil)
    let commentCount = BehaviorRelay<Int?>(value: nil)
    let viewCount = BehaviorRelay<Int?>(value: nil)

    let tag = BehaviorRelay<[String]?>(value: nil)
    let createdTime = BehaviorRelay<Date?>(value: nil)

    let isLiked = BehaviorRelay<Bool?>(value: nil)

    let disposeBag = DisposeBag()
    var services: CoatCodeService
    var post: Post

    init(post: Post, services: CoatCodeService) {
        self.post = post
        self.services = services

        self.username.accept(post.owner.username)
        self.profileImageUrl.accept(post.owner.image)
        self.imageUrls.accept(post.imageURLs)
        self.title.accept(post.title)
        self.content.accept(post.content)
        self.likeCount.accept(post.likeCount)
        self.commentCount.accept(post.commentCount)
        self.viewCount.accept(post.viewCount)
        self.tag.accept(post.tag)
        self.createdTime.accept(post.createdAt)

        // 좋아요 여부
        if let isLiked = post.likedPeople?.contains(DatabaseManager.shared.getCurrentUser().id) {
            self.isLiked.accept(isLiked)
        } else {
            self.isLiked.accept(false)
        }
    }

    func like() {
        FeedbackManager.impactFeedback(style: .medium)
        self.services.likePost(postId: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLiked.accept(true)
                self.likeCount.accept((self.likeCount.value ?? 0) + 1)
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }

    func unLike() {
        self.services.unlikePost(postId: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.isLiked.accept(false)
                self.likeCount.accept((self.likeCount.value ?? 0) - 1)
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }

    func checkLiking() {
        self.services.isLikedPost(postId: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.isLiked.accept(true)
            }, onError: { [weak self] _ in
                self?.isLiked.accept(false)
            }).disposed(by: disposeBag)
    }
}
