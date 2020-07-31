//
//  ResponseError.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct ResponseError: Decodable, Error {
    var statusCode: Int?
    let message: String
    let documentation_url: String
}
