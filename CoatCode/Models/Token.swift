//
//  Token.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

struct Token: Decodable {
  let tokenType: String
  let accessToken: String
  let refreshToken: String
  let expiresAt: TimeInterval
}
