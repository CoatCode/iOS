//
//  Configs.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

struct Configs {
    
    struct App {
        static let bundleIdentifier = "com.tistory.axe-num1.CoatCode"
    }
    
    // 외부 IP: http://coatcode.pythonanywhere.com
    // 내부 IP: http://10.80.161.202:8080
    struct Network {
        static let baseURL = URL(string: "http://10.80.161.202:8080")!
    }
    
    struct BaseDimensions {
        
    }
    
    struct BaseColor {
        static let signatureColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        static let navBarTintColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
        static let tagColor = UIColor(red: 0.00, green: 0.17, blue: 0.42, alpha: 1.00)
    }
    
    struct Path {
        
    }
    
}
