//
//  SignInResponse.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let name: String
    let avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case email
        case name
        case avatarUrl = "avatar_url"
    }
}
