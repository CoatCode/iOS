//
//  AuthManager.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/29.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let loggedIn = BehaviorRelay<Bool>(value: false)

class AuthManager {

    /// The default singleton instance.
    static let shared = AuthManager()

    // MARK: - Properties
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = KeychainManager.shared.keychain

    let tokenChanged = PublishSubject<Token?>()

    private init() { }

    var token: Token? {
        get {
            guard let jsonString = keychain[tokenKey] else { return nil }
            let jsonData = jsonString.data(using: .utf8)!
            let token = try? JSONDecoder().decode(Token.self, from: jsonData)
            return token
        }
        set {
            if let token = newValue, let jsonData = try? JSONEncoder().encode(token) {
                let jsonString = String(data: jsonData, encoding: .utf8)
                keychain[tokenKey] = jsonString
            } else {
                keychain[tokenKey] = nil
            }
            tokenChanged.onNext(newValue)
        }
    }

    class func getAccessToken() -> String {
        if let token = AuthManager.shared.token {
            return token.accessToken
        } else {
            return "AccessTokenError"
        }
    }

    class func getRefreshToken() -> String {
        if let token = AuthManager.shared.token {
            return token.refreshToken
        } else {
            return "RefreshTokenEmpty"
        }
    }

    class func setToken(token: Token) {
        AuthManager.shared.token = token
    }

    class func removeToken() {
        AuthManager.shared.token = nil
    }

    /// refreshToken의 만료일을 확인합니다.
//    @discardableResult
//    class func checkRefreshTokenValid() -> Bool {
//        AuthManager.shared.token?.refreshTokenExpiresAt
//
//        // 만료날짜를 확인 하여 결과를 반환
//    }

}
