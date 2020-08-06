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
import KeychainAccess

let loggedIn = BehaviorRelay<Bool>(value: false)

class AuthManager {
    
    /// The default singleton instance.
    static let shared = AuthManager()

    // MARK: - Properties
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = Keychain(service: "com.tistory.axe-num1.CoatCode")

    let tokenChanged = PublishSubject<Token?>()

    init() {
        loggedIn.accept(hasValidToken)
    }

    var token: Token? {
        get {
            guard let jsonString = keychain[tokenKey] else { return nil }
            let jsonData = jsonString.data(using: .utf8)!
            let token = try! JSONDecoder().decode(Token.self, from: jsonData)
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
            loggedIn.accept(hasValidToken)
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
            return "RefreshTokenError"
        }
    }

    var hasValidToken: Bool {
        return token?.isValid == true
    }

    class func setToken(token: Token) {
        AuthManager.shared.token = token
    }

    class func removeToken() {
        AuthManager.shared.token = nil
    }

    class func tokenValidated() {
        AuthManager.shared.token?.isValid = true
    }
    
}
