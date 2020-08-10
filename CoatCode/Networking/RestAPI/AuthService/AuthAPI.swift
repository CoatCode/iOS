//
//  AuthAPI.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/05.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import Moya

// MARK: - API
enum AuthAPI {
    /// 토큰 재발급
    case renewalToken(String)
}

extension AuthAPI: BaseAPI {
    var path: String {
        switch self {
        case .renewalToken:
            return "/refresh"
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
                parameters: ["refresh": refreshToken],
                encoding: JSONEncoding.default
            )
        }
    }
}
