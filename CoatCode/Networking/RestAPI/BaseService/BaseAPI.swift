//
//  BaseAPI.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import Moya

protocol BaseAPI: TargetType { }

extension BaseAPI {
    var baseURL: URL { Configs.Network.baseURL }

    var method: Moya.Method { .get }

    var sampleData: Data { Data() }

    var task: Task { .requestPlain }

    var headers: [String: String]? { nil }
}
