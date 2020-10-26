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
