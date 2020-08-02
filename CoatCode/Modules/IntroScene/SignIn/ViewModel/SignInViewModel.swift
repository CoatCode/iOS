//
//  LoginViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CryptoSwift

class SignInViewModel: ViewModelType {
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let isLogin: Driver<Bool>
    }
    
    let disposeBag = DisposeBag()
    let isSuccess = BehaviorRelay(value: false)
    let isLoading = BehaviorRelay(value: false)
    let errorMsg = BehaviorRelay(value: "")
    
    
    let loading = ActivityIndicator()
    
    
    
    let service = CoatCodeService.shared
    
    //    var loginRequest = PostLoginRequest()
    
    let id = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")
    
    func transform(input: Input) -> Output {
        
        //        loginRequest.id = self.id.value
        //        loginRequest.pw = self.pw.value
        
        //        let response = input.trigger
        
        input.trigger.do { [weak self] in
            guard let self = self else { return }
            
            self.service.signIn(email: self.id.value, password: self.pw.value.sha256())
                .map(User.self)
                .trackActivity(self.loading)
                .subscribe(
                    onNext: {
                        AuthManager.setToken(token: $0.token)
                    }, onError: {
                        print("==== error: \($0)")
                    }
                ).disposed(by: self.disposeBag)
        }
            
            
//            .subscribe(
//                onSuccess: {
//                    AuthManager.setToken(token: $0.token)
//
//
//
//                    print("=== user: \($0)")
//                },
//                onError: {
//                    print("==== error: \($0)")
//                }
//            ).disposed(by: disposeBag)
        
        return Output(isLogin: )
    }
    
    
    
}
