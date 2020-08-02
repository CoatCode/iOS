//
//  handleResponse.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import Moya
import RxSwift

/// 서버에서 보내주는 오류 문구 파싱용
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func handleResponse() -> Single<Element> {
        return flatMap { response in
            // 토큰 재발급 받았을 때 토큰 변경함
            if let newToken = try? response.map(Token.self) {
                AuthManager.shared.token?.accessToken = newToken.accessToken
                AuthManager.shared.token?.refreshToken = newToken.refreshToken
            }
            
            if (200 ... 299) ~= response.statusCode {
                return Single.just(response)
            }
            
            if var error = try? response.map(ResponseError.self) {
                error.statusCode = response.statusCode
                return Single.error(error)
            }
            
            // Its an error and can't decode error details from server, push generic message
            let genericError = ResponseError(
                statusCode: response.statusCode,
                message: "empty message",
                documentation_url: "doc url")
            return Single.error(genericError)
        }
    }
}

struct ResponseError: Decodable, Error {
    var statusCode: Int?
    let message: String
    let documentation_url: String
}
