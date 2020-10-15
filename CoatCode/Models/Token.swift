//
//  Token.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct Token: Codable {
    var tokenType: String
    var accessToken: String
    var expiresAt: Date
    var refreshToken: String
    var refreshTokenExpiresAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case expiresAt = "expires_at"
        case refreshToken = "refresh_token"
        case refreshTokenExpiresAt = "refresh_token_expires_at"
    }
}
