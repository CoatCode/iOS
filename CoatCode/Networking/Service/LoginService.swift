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

final class LoginService {
    
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
    
    var method: Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .login(let email, let password):
            let param = ["email": email, "password": password]
            return .requestParameters(parameters: param, encoding: JSONEncoding)
        }
    }
}
