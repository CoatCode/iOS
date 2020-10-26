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

    func signUp(email: String, password: String, username: String, image: UIImage?) -> Single<Void> {
        return requestWithoutMapping(.signUp(email: email, password: password.sha512(), username: username, image: image))
    }

    func profile() -> Single<User> {
        return requestObject(.profile, type: User.self)
    }

    func userPosts(userId: Int) -> Single<[Post]> {
        return requestArray(.userPosts(userId: userId), type: Post.self)
    }

    func writePost(images: [UIImage], title: String, content: String?, tag: [String]?) -> Single<Void> {
        return requestWithoutMapping(.writePost(images: images, title: title, content: content, tag: tag))
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

    func editPost(postId: Int, images: [UIImage], title: String, content: String?, tag: [String]?) -> Single<Void> {
        return requestWithoutMapping(.editPost(postId: postId, images: images, title: title, content: content, tag: tag))
    }

    func deletePost(postId: Int) -> Single<Void> {
        return requestWithoutMapping(.deletePost(postId: postId))
    }

    func likedPeoples(postId: Int) -> Single<Void> {
        return requestWithoutMapping(.likes(postId: postId))
    }

    func likePost(postId: Int) -> Single<Void> {
        return requestWithoutMapping(.likePost(postId: postId))
    }
    func isLikedPost(postId: Int) -> Single<Void> {
        return requestWithoutMapping(.isLikedPost(postId: postId))
    }

    func unlikePost(postId: Int) -> Single<Void> {
        return requestWithoutMapping(.unlikePost(postId: postId))
    }

    func writeComment(postId: Int, content: String) -> Single<Void> {
        return requestWithoutMapping(.writeComment(postId: postId, content: content))
    }

    func postComments(postId: Int) -> Single<[Comment]> {
        return requestArray(.comments(postId: postId), type: Comment.self)
    }

    func editComment(postId: Int, commentId: Int, content: String) -> Single<Void> {
        return requestWithoutMapping(.editComment(postId: postId, commentId: commentId, content: content))
    }

    func deleteComment(postId: Int, commentId: Int) -> Single<Void> {
        return requestWithoutMapping(.deleteComment(postId: postId, commentId: commentId))
    }

    func searchPost(page: Int, query: String) -> Single<[Post]> {
        return requestArray(.searchPost(page: page, query: query), type: Post.self)
    }

    //    func searchProduct() {
    //        return requestArray(.searchProduct(page: <#T##Int#>, query: <#T##String#>), type: <#T##(Decodable & Encodable).Protocol#>)
    //    }

    func searchUser(page: Int, query: String) -> Single<[User]> {
        return requestArray(.searchUser(page: page, query: query), type: User.self)
    }

    func follower(userId: Int) -> Single<[User]> {
        return requestArray(.follower(userId: userId), type: User.self)
    }

    func following(userId: Int) -> Single<[User]> {
        return requestArray(.following(userId: userId), type: User.self)
    }

    func followUser(userId: Int) -> Single<Void> {
        return requestWithoutMapping(.followUser(userId: userId))
    }

    func isFollowUser(userId: Int) -> Single<Void> {
        return requestWithoutMapping(.isFollowUser(userId: userId))
    }

    func unFollowUser(userId: Int) -> Single<Void> {
        return requestWithoutMapping(.unFollowUser(userId: userId))
    }

}

extension CoatCodeService {

    private func requestWithoutMapping(_ target: CoatCodeAPI) -> Single<Void> {
        return request(target)
            .map { _ in }
    }

    private func requestObject<T: Codable>(_ target: CoatCodeAPI, type: T.Type) -> Single<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return request(target)
            .map(T.self, using: decoder)
    }

    private func requestArray<T: Codable>(_ target: CoatCodeAPI, type: T.Type) -> Single<[T]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return request(target)
            .map([T].self, using: decoder)
    }
}
