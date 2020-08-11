//
//  User.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

struct User: Codable, ResponseProtocol {
    var status: Int?
    var message: String?
    
    var email: String
    var name: String
    var avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case message
        case email
        case name
        case avatarUrl = "avatar_url"
    }
}
