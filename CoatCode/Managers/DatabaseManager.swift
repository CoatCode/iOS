//
//  DatabaseManager.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/07.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private init() {}
    
    private let realm = try! Realm()
    
    func saveUser(userData: User) {
        
    }
    
    func removeCurrentUser() {
        
    }
    
    
    
}
