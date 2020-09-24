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

    @objc dynamic var email = ""
    @objc dynamic var username = ""
    @objc dynamic var profile = ""
    
    private enum CodingKeys: String, CodingKey {
        case email
        case username
        case profile
    }
    
}
