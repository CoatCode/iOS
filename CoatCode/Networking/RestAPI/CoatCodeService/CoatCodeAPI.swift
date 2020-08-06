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
    // MARK: - 로그인 & 회원가입 관련
    case signIn(String, String)
    case signUp(String, String)
    case checkEmail(String)
    
    // MARK: - Authentication is required
    // MARK: - 유저 관련
    case profile
    
}

extension CoatCodeAPI: BaseAPI {
    var path: String {
        switch self {
        case .signIn:
            return "/auth/login"
        case .signUp:
            return "/auth/registration"
        case .checkEmail:
            return "/auth/checkEmail"
        case .profile:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn, .signUp, .checkEmail:
            return .post
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return ["Authorization": AuthManager.getAccessToken()]
    }
    
    var task: Task {
        switch self {
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
        case .signUp(let email, let password):
            params["email"] = email
            params["password"] = password
        case .checkEmail(let emailAuthCode):
            params["authCode"] = emailAuthCode
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
