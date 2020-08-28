//
//  SignIn.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct SignInResponse: Codable, ResponseProtocol {
    var status: Int?
    var message: String?
    
    var token: Token?
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case token
    }
}
