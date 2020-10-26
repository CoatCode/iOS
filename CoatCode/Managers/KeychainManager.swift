//
//  KeychainManager.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/05.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainManager {

    static let shared = KeychainManager()

    fileprivate let usernameKey = "usernameKey"

    private init() { }

    let keychain = Keychain(service: Configs.App.bundleIdentifier)

    var username: String? {
        get {
            return keychain[usernameKey]
        }
        set {
            keychain[usernameKey] = "\(newValue!)"
        }
    }

}
