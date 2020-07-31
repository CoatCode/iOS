//
//  SessionService.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift

protocol Authentication {
    func signIn() -> Single<SignInResponse>
}
 
class SessionService: Authentication {
    
    let networkClient = NetworkClient()
    
    func signIn() -> Single<SignInResponse> {
        return Single<SignInResponse>.create { single in
            // call to backend
            networkClient.postRequest(SignInResponse.self, endpoint: "", param: )
            
            single(.success(SignInResponse(token: "12345", userId: "5678")))
            return Disposables.create()
        }
    }
}
