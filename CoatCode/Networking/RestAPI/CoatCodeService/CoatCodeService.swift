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
    
    func checkEmail(emailAuthCode: String) -> Single<Response> {
        return request(.checkEmail(emailAuthCode))
    }
    
    func profile() -> Single<Response> {
        return request(.profile)
    }
}

