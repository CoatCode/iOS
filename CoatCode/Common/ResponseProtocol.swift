//
//  ResponseProtocol.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

protocol ResponseProtocol: Decodable {
    var status: Int? { get set }
    var message: String? { get set }
}
