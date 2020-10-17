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
    
    let disposeBag = DisposeBag()
    var services: CoatCodeService!
    var post: Post
    
    init(post: Post, services: CoatCodeService) {
        self.post = post
        self.services = services
        
        self.contentImageUrls.accept(post.imageURLs)
        self.title.accept(post.title)
        self.content.accept(post.content)
        self.likeCount.accept(post.likeCount)
        self.commentCount.accept(post.commentCount)
        self.viewCount.accept(post.viewCount)
        self.tag.accept(post.tag)
        self.createdTime.accept(post.createdAt)
        
        self.services.isLikedPost(postId: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.isLiked.accept(true)
            }, onError: { [weak self] _ in
                self?.isLiked.accept(false)
            }).disposed(by: disposeBag)
    }
    
    func like() {
        self.services.likePost(postId: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLiked.accept(true)
                self.likeCount.accept((self.likeCount.value ?? 0) + 1)
                self.post.likeCount = (self.likeCount.value ?? 0) + 1
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    func unLike() {
        self.services.unlikePost(postId: post.id)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLiked.accept(false)
                self.likeCount.accept((self.likeCount.value ?? 0) - 1)
                self.post.likeCount = (self.likeCount.value ?? 0) - 1
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
}
