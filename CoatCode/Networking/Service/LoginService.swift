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

final class LoginService: BaseService<LoginAPI> {
    static let shared = LoginService()
    private override init() {}
    
    func login(email: String, password: String) -> Single<Response> {
        return request(.login(email, password))
    }
}

enum LoginAPI {
    case login(String, String)
}

extension LoginAPI: BaseAPI {
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        }
    }
    
    var method: Moya.Method { .post }

    var task: Task {
        switch self {
        case .login(let email, let password):
            let param = ["email": email, "password": password]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
}
