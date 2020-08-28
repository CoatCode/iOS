//
//  ProfileResponse.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/28.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

class ProfileResponse: Codable, ResponseProtocol {
    var status: Int?
    var message: String?
    
    var email: String?
    var username: String?
    var profile: String?
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        
        case email
        case username
        case profile
    }
}
