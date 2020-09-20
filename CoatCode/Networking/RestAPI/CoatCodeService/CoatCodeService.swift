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
        return requestObject(.signIn(email, password.sha512()), type: Token.self)
    }
    
    func signUp(email: String, password: String, userName: String, profile: String?) -> Single<Void> {
        return requestWithoutMapping(.signUp(email, password.sha512(), userName, profile))
    }
    
    func profile() -> Single<ProfileResponse> {
        return requestObject(.profile, type: ProfileResponse.self)
    }
    
    func allFeedPosts(page: Int) -> Single<[Post]> {
        return requestArray(.allFeedPosts(page), type: Post.self)
    }
    
    func followFeedPosts(page: Int) -> Single<[Post]> {
        return requestArray(.followFeedPosts(page), type: Post.self)
    }
    
    func popularFeedPosts(page: Int) -> Single<[Post]> {
        return requestArray(.popularFeedPosts(page), type: Post.self)
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
