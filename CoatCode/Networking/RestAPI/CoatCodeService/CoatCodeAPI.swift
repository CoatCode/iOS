//
//  CoatCodeAPI.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/05.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum CoatCodeAPI {

    // MARK: - Authentication is not required
    case signIn(email: String, password: String)
    case signUp(email: String, password: String, username: String, image: UIImage?)

    case userPosts(userId: Int)

    case allFeedPosts(page: Int)
    case popularFeedPosts(page: Int)

    case likes(postId: Int)
    case comments(postId: Int)

    case searchPost(page: Int, query: String)
    case searchProduct(page: Int, query: String)
    case searchUser(page: Int, query: String)

    case follower(userId: Int)
    case following(userId: Int)

    // MARK: - Authentication is required
    case profile
    
    case followFeedPosts(page: Int)

    case writePost(images: [UIImage], title: String, content: String?, tag: [String]?)
    case editPost(postId: Int, images: [UIImage], title: String, content: String?, tag: [String]?)
    case deletePost(postId: Int)

    case likePost(postId: Int)
    case isLikedPost(postId: Int)
    case unlikePost(postId: Int)

    case writeComment(postId: Int, content: String)
    case editComment(postId: Int, commentId: Int, content: String)
    case deleteComment(postId: Int, commentId: Int)

    case followUser(userId: Int)
    case isFollowUser(userId: Int)
    case unFollowUser(userId: Int)
}

extension CoatCodeAPI: BaseAPI {
    var path: String {
        switch self {
        case .signIn:
            return "/auth/login"
        case .signUp:
            return "/auth/sign-up"

        case .profile:
            return "/user"
        case .userPosts(let userId):
            return "/user/\(userId)/posts"

        case .writePost:
            return "/feed/post"
        case .allFeedPosts:
            return "/feed/post/all"
        case .followFeedPosts:
            return "/feed/post/follow"
        case .popularFeedPosts:
            return "/feed/post/popular"
        case .editPost(let postId, _, _, _, _),
             .deletePost(let postId):
            return "/feed/post/\(postId)"

        case .likes(let postId):
            return "/feed/post/\(postId)/likes"
        case .likePost(let postId),
             .isLikedPost(let postId),
             .unlikePost(let postId):
            return "feed/post/\(postId)/like"

        case .writeComment(let postId, _):
            return "/feed/post/\(postId)/comment"
        case .comments(let postId):
            return "/feed/post/\(postId)/comments"
        case .editComment(let postId, let commentId, _),
             .deleteComment(let postId, let commentId):
            return "/feed/post/\(postId)/comment/\(commentId)"

        case .searchPost:
            return "/search/post"
        case .searchProduct:
            return "/search/product"
        case .searchUser:
            return "/search/user"

        case .follower(let userId):
            return "/user/\(userId)/follower"
        case .following(let userId):
            return "/user/\(userId)/following"
        case .followUser(let userId),
             .isFollowUser(let userId),
             .unFollowUser(let userId):
            return "/user/\(userId)/follow"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .writePost, .likePost, .writeComment, .followUser:
            return .post
        case .editPost, .editComment:
            return .put
        case .deletePost, .unlikePost, .deleteComment, .unFollowUser:
            return .delete
        default:
            return .get
        }
    }

    var headers: [String: String]? {
        switch self {
        // None Authentication
        case .signIn, .signUp, .userPosts, .allFeedPosts, .popularFeedPosts, .likes, .comments, .searchPost, .searchProduct, .searchUser, .follower, .following:
            break
        // Authentication
        default:
            return ["Authorization": "Bearer \(AuthManager.getAccessToken())"]
        }
        return nil
    }

    var task: Task {
        switch self {
        // Post
        case .signIn, .writeComment, .editComment:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            }
            return .requestPlain

        // 회원가입 Multipart Upload
        case .signUp(let email, let password, let username, let image):
            var formData = [MultipartFormData]()

            formData.append(.init(provider: .data(email.data(using: .utf8)!), name: "email"))
            formData.append(.init(provider: .data(password.data(using: .utf8)!), name: "password"))
            formData.append(.init(provider: .data(username.data(using: .utf8)!), name: "username"))

            if let data = image?.jpegData(compressionQuality: 1.0) {
                formData.append(.init(provider: .data(data), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg"))
            }

            return .uploadMultipart(formData)

        // 게시물 작성 Multipart Upload
        case .writePost(let images, let title, let content, let tag),
             .editPost(_, let images, let title, let content, let tag):
            var formData = [MultipartFormData]()

            images.enumerated().forEach { (index, image) in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    formData.append(.init(provider: .data(data), name: "image\(index)", fileName: "image\(index).jpeg", mimeType: "image/jpeg"))
                }
            }

            formData.append(.init(provider: .data(title.data(using: .utf8)!), name: "title"))

            if let content = content {
                formData.append(.init(provider: .data(content.data(using: .utf8)!), name: "content"))
            }

            if let tag = tag {
                tag.enumerated().forEach { (index, tag) in
                    formData.append(.init(provider: .data(tag.data(using: .utf8)!), name: "tag[\(index)]"))
                }
            }

            return .uploadMultipart(formData)

        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            }
            return .requestPlain
        }
    }

    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .signIn(let email, let password):
            params["email"] = email
            params["password"] = password
        case .allFeedPosts(let page),
             .followFeedPosts(let page),
             .popularFeedPosts(let page):
            params["page"] = page
        case .writeComment(_, let content):
            params["content"] = content
        case .searchPost(let page, let query),
             .searchProduct(let page, let query),
             .searchUser(let page, let query):
            params["page"] = page
            params["query"] = query

        default: break
        }
        return params
    }

    // 샘플 데이터 추가 예정
    //    var sampleData: Data {
    //        var dataUrl: URL?
    //        switch self {
    //
    //        }
    //        if let url = dataUrl, let data = try? Data(contentsOf: url) {
    //            return data
    //        }
    //        return Data()
    //    }
}
