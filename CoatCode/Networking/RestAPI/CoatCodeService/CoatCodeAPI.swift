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
    case signUp(email: String, password: String, username: String, profile: String?)
    
    // MARK: - Authentication is required
    case profile
    
    case writePost(images: [UIImage], title: String, content: String, tag: String)
    case allFeedPosts(page: Int)
    case followFeedPosts(page: Int)
    case popularFeedPosts(page: Int)
    case modifyPost(postId: Int, images: [UIImage], title: String, content: String, tag: String)
    case deletePost(postId: Int)
    
    case likedPeoples(postId: Int)
    case likePost(postId: Int)
    case isLikedPost(postId: Int)
    case unlikePost(postId: Int)
    
    case writeComment(postId: Int, content: String)
    case postComments(postId: Int)
    case modifyComment(postId: Int, commentId: Int, content: String)
    case deleteComment(postId: Int, commentId: Int)
    
    case searchPost(page: Int, query: String)
    case searchProduct(page: Int, query: String)
    case searchUser(page: Int, query: String)
    
    case follower(userId: Int)
    case following(userId: Int)
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
            
        case .writePost:
            return "/feed/post"
        case .allFeedPosts:
            return "/feed/post/all"
        case .followFeedPosts:
            return "/feed/post/follow"
        case .popularFeedPosts:
            return "/feed/post/popular"
        case .modifyPost(let postId, _, _, _, _),
             .deletePost(let postId):
            return "/feed/post/\(postId)"
            
        case .likedPeoples(let postId):
            return "/post/\(postId)/liked-peoples"
        case .likePost(let postId),
             .isLikedPost(let postId),
             .unlikePost(let postId):
            return "/post/\(postId)/like"
            
        case .writeComment(let postId, _):
            return "/post/\(postId)/comment"
        case .postComments(let postId):
            return "/post/\(postId)/comments"
        case .modifyComment(let postId, let commentId, _),
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
        case .modifyPost, .modifyComment:
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
        case .signIn, .signUp:
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
        case .signIn, .signUp, .likePost, .writeComment, .modifyComment, .followUser:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            }
            return .requestPlain
            
        // 게시물 Multipart
        case .writePost(let images, let title, let content, let tag),
             .modifyPost(_, let images, let title, let content, let tag):
            var formData = [MultipartFormData]()
            
            for (index, image) in images.enumerated() {
                if let data = image.jpegData(compressionQuality: 1.0) {
                    formData.append(MultipartFormData(provider: .data(data), name: "image\(index)", fileName: "image\(index).jpeg", mimeType: "image/jpeg"))
                }
            }
            
            formData.append(.init(provider: .data(title.data(using: .utf8)!), name: "title"))
            formData.append(.init(provider: .data(content.data(using: .utf8)!), name: "content"))
            formData.append(.init(provider: .data(tag.data(using: .utf8)!), name: "tag"))
            
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
        case .signUp(let email, let password, let username, let profile):
            params["email"] = email
            params["password"] = password
            params["username"] = username
            params["profile"] = profile
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
