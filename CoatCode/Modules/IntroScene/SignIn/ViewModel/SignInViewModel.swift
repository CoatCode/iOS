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

class SignInViewModel {
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let response: Driver<PostLogin.Response>
    }
    
    let disposeBag = DisposeBag()
    let isSuccess = BehaviorRelay(value: false)
    let isLoading = BehaviorRelay(value: false)
    let errorMsg = BehaviorRelay(value: "")
    
    let networkClient = NetworkClient()
    var loginRequest = PostLoginRequest()
    
    let id = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")

    func transform(input: Input) -> Output {
        
        loginRequest.id = self.id.value
        loginRequest.pw = self.pw.value
        
        let response = input.trigger
            .do(onNext: { [weak self] in self?.isLoading.accept(true)})
            .flatMapLatest {
                self.networkClient.postRequest(PostLogin.Response.self, endpoint: "", param: self.loginRequest)
            }
            .do(onNext: { [weak self] in self?.isLoading.accept(false)})
        
        return Output(response: response.asDriver(onErrorJustReturn: .init()))
    }
    
    
    
}
