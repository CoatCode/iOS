//
//  AuthService.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import Moya
import RxSwift

/// 인증 관련 API
final class AuthService: BaseService<AuthAPI> {
    static let shared = AuthService()
    private override init() {}
    
    /// 토큰 재발급
    func renewalToken(refreshToken: String) -> Single<Response> {
        return request(.renewalToken(refreshToken))
    }
}

// MARK: - API
enum AuthAPI {
    /// 토큰 재발급
    case renewalToken(String)
}

extension AuthAPI: BaseAPI {
    var path: String {
        let apiPath = "/api-as/v1"
        
        switch self {
        case .renewalToken:
            return "\(apiPath)/\("renewalToken".lowercased())"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .renewalToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .renewalToken(refreshToken):
            return .requestParameters(
                parameters: ["refreshToken": refreshToken],
                encoding: JSONEncoding.default
            )
        }
    }
}
