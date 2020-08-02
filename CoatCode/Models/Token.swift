//
//  Token.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct Token: Codable {
    
    var isValid: Bool
    var tokenType: String
    var accessToken: String
    var refreshToken: String
    var expiresAt: TimeInterval
    
    private enum CodingKeys: String, CodingKey {
        case isValid
        case tokenType = "token_type"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
    }
}
