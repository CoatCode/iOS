//
//  ErrorResponse.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/11.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable, Error {
    var status: Int?
    let message: [String]
}
