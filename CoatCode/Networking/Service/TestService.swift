//
//  TestService.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import Moya
import RxSwift

final class TestService: BaseService<TestAPI> {
    static let shared = TestService()
    private override init() {}
    
    /// 아이디로 사용자 정보 가져오기
    /// - Parameters:
    ///   - name: 로그인 아이디
    func user(name: String) -> Single<Response> {
        return request(.profile(name))
    }
}

enum TestAPI {
    case profile(String)
}

extension TestAPI: BaseAPI {
    var path: String {
        switch self {
        case let .profile(name):
            return "/users/\(name)"
        }
    }
}
