//
//  User.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object, Codable {

    @objc dynamic var id = -1
    @objc dynamic var email = ""
    @objc dynamic var username = ""
    @objc dynamic var image: String? = ""
    @objc dynamic var followers = -1
    @objc dynamic var following = -1

    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case image = "profile"
        case followers
        case following
    }
}
