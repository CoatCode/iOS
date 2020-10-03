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
    
    case allFeedPosts(page: Int)
    case followFeedPosts(page: Int)
    case popularFeedPosts(page: Int)
    
    case feedComments(postId: Int)
    case writeComment(postId: Int, content: String)
    
    case isLikedPost(postId: Int)
    case likePost(postId: Int)
    case unlikePost(postId: Int)
    
}

extension CoatCodeAPI: BaseAPI {
    var path: String {
        switch self {
        case .signIn:
            return "/auth/login"
        case .signUp:
            return "/auth/signUp"
        case .profile:
            return "/user"
        case .allFeedPosts:
            return "/feed/post/all"
        case .followFeedPosts:
            return "/feed/post/follow"
        case .popularFeedPosts:
            return "/feed/post/popular"
        case .feedComments(let postId):
            return "/post/\(postId)/comments"
        case .isLikedPost(let postId),
             .likePost(let postId),
             .unlikePost(let postId):
            return "/post/\(postId)/like"
        case .writeComment(let postId, _):
            return "/post/\(postId)/comment"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .writeComment:
            return .post
        case .likePost:
            return .put
        case .unlikePost:
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
            return ["authorization": "Bearer \(AuthManager.getAccessToken())"]
        }
        return nil
    }
    
    var task: Task {
        switch self {
        // Post
        case .signIn, .signUp, .writeComment:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            }
            return .requestPlain
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
        case .allFeedPosts(let page):
            params["page"] = page
        case .followFeedPosts(let page):
            params["page"] = page
        case .popularFeedPosts(let page):
            params["page"] = page
        case .writeComment(_, let content):
            params["content"] = content
        default: break
        }
        return params
    }
    
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
