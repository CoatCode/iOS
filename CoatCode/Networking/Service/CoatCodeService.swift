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

final class CoatCodeService: BaseService<CoatCodeAPI> {
    static let shared = CoatCodeService()
    private override init() {}
    
    func signIn(email: String, password: String) -> Single<Response> {
        return request(.signIn(email, password))
    }
    
    func signUp(email: String, password: String) -> Single<Response> {
        return request(.signUp(email, password))
    }
    
    func emailCheck(emailAuthCode: String) -> Single<Response> {
        return request(.checkEmail(emailAuthCode))
    }
}

enum CoatCodeAPI {
    
    // MARK: - Authentication is not required
    // MARK: - 로그인 & 회원가입 관련
    case signIn(String, String)
    case signUp(String, String)
    case checkEmail(String)
    
    // MARK: - Authentication is required
    // MARK: - 프로필 관련
    
    
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmail, .signIn, .signUp:
            return .post
        default:
            return .get
        }
    }
    
    var headers: [String: String]? {
        if let token = AuthManager.shared.token {
            return ["Authorization": "token \(token)"]
//            switch token.type() {
//            case .basic(let token):
//                return ["Authorization": "Basic \(token)"]
//            case .personal(let token):
//                return ["Authorization": "token \(token)"]
//            case .oAuth(let token):
//                return ["Authorization": "token \(token)"]
//            case .unauthorized: break
//            }
        }
        return nil
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
    
    var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            }
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        var dataUrl: URL?
        switch self {
            
        }
        if let url = dataUrl, let data = try? Data(contentsOf: url) {
            return data
        }
        return Data()
    }
    
}
