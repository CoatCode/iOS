//
//  Network.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/29.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import Moya

final class APIService: BaseRepository<LoginAPI> {

    static let shared = APIService()
    private override init() {}
    
    func login(email: String, password: String, _ completion: @escaping (User?, Error?) -> Void) {
        rx.request(.login)
            .filterSuccessfulStatusCodes()
            .map(User.self)
//            .debug()
            .subscribe(onSuccess: { completion($0, nil) }, onError: { completion(nil, $0) })
            .disposed(by: disposeBag)
    }
    
    
}







public enum NetworkError: Error {
    case errorStatusCode(statusCode: Int)
    case notConnected
    case cancelled
    case urlGeneration
    case requestError(Error?)
}

extension NetworkError {
    var isNotFoundError: Bool { return hasCodeError(404) }
    
    func hasCodeError(_ codeError: Int) -> Bool {
        switch self {
        case let .errorStatusCode(code):
            return code == codeError
        default: return false
        }
    }
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
