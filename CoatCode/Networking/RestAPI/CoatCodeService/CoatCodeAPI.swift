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
    case signIn(String, String)
    case signUp(String, String, String, String?)
    
    // MARK: - Authentication is required
    case profile
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp:
            return .post
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signIn, .signUp:
            break
        default:
            return ["authorization": "Bearer \(AuthManager.getAccessToken())"]
        }
        return nil
    }
    
    var task: Task {
        switch self {
        case .profile:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            }
            return .requestPlain
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
