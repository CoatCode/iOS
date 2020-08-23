//
//  String.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/23.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}
