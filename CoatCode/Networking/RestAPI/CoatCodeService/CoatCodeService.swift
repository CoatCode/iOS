//
//  loginService.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import CryptoSwift

final class CoatCodeService: BaseService<CoatCodeAPI> {
    
    func signIn(email: String, password: String) -> Single<Token> {
        return requestObject(.signIn(email: email, password: password.sha512()), type: Token.self)
    }
    
    func signUp(email: String, password: String, username: String, profile: String?) -> Single<Void> {
        return requestWithoutMapping(.signUp(email: email, password: password.sha512(), username: username, profile: profile))
    }
    
    func profile() -> Single<User> {
        return requestObject(.profile, type: User.self)
    }
    
    func allFeedPosts(page: Int) -> Single<[Post]> {
        return requestArray(.allFeedPosts(page: page), type: Post.self)
    }
    
    func followFeedPosts(page: Int) -> Single<[Post]> {
        return requestArray(.followFeedPosts(page: page), type: Post.self)
    }
    
    func popularFeedPosts(page: Int) -> Single<[Post]> {
        return requestArray(.popularFeedPosts(page: page), type: Post.self)
    }
    
    func feedComments(postId: Int) -> Single<[Comment]> {
        return requestArray(.feedComments(postId: postId), type: Comment.self)
    }
    
    func checkLiking(postId: Int) -> Single<Void> {
        return requestWithoutMapping(.checkLiking(postId: postId))
    }
    
    func likePost(postId: Int) -> Single<Void> {
        return requestWithoutMapping(.likePost(postId: postId))
    }
    
    func unlikePost(postId: Int) -> Single<Void > {
        return requestWithoutMapping(.unlikePost(postId: postId))
    }
    
}

extension CoatCodeService {
    
    private func requestWithoutMapping(_ target: CoatCodeAPI) -> Single<Void> {
        return request(target)
            .map { _ in }
    }
    
    private func requestObject<T: Codable>(_ target: CoatCodeAPI, type: T.Type) -> Single<T> {
        return request(target)
            .map(T.self)
    }
    
    private func requestArray<T: Codable>(_ target: CoatCodeAPI, type: T.Type) -> Single<[T]> {
        return request(target)
            .map([T].self)
    }
}
