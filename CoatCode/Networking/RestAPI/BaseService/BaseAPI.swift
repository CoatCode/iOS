//
//  BaseAPI.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import Moya

protocol BaseAPI: TargetType {}

// 외부 IP: http://gi399819.pythonanywhere.com/
// 내부 IP: http://10.80.161.202:8080

extension BaseAPI {
    var baseURL: URL { URL(string: "http://gi399819.pythonanywhere.com")! }
    
    var method: Moya.Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task { .requestPlain }
    
    var headers: [String: String]? { nil }
}
