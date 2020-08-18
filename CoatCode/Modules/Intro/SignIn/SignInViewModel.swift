//
//  LoginViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import CryptoSwift

class SignInViewModel: ViewModelType, Stepper, ServicesViewModel {
    
    struct Input {
        let signInTrigger: Observable<Void>
    }
    
    struct Output {
        let loginButtonEnabled: Driver<Bool>
        let isLoginSuccess: Observable<Void>
    }
    
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var services: CoatCodeService!
    
    let loading = ActivityIndicator()
    var tokenSaved = PublishSubject<Void>()
    let loginSuccess = PublishSubject<Void>()
    
    let id = BehaviorRelay(value: "")
    let pw = BehaviorRelay(value: "")
    
    func transform(input: Input) -> Output {
        
        let tokenRequest = input.signInTrigger.flatMapLatest {
            return self.services.signIn(email: self.id.value, password: self.pw.value.sha256())
                .map(SignIn.self)
                .trackActivity(self.loading)
        }
        
        tokenRequest.subscribe(onNext: { response in
            guard let token = response.token else { return }
            AuthManager.setToken(token: token)
            self.tokenSaved.onNext(())
        }, onError: { error in
            AuthManager.removeToken()
        }).disposed(by: self.disposeBag)
        
        let profileRequest = tokenSaved.flatMapLatest {
            return self.services.profile()
                .map(User.self)
                .trackActivity(self.loading)
        }
        
        profileRequest.subscribe(onNext: { user in
            // user response값 저장
            AuthManager.tokenValidated()
            // coordinator 처리
            self.loginSuccess.onNext(())
        }, onError: { error in
            AuthManager.removeToken()
        }).disposed(by: disposeBag)
        
        let loginButtonEnabled = BehaviorRelay.combineLatest(id, pw, self.loading.asObservable()) {
            return !$0.isEmpty && !$1.isEmpty && !$2
        }.asDriver(onErrorJustReturn: false)
        
        return Output(loginButtonEnabled: loginButtonEnabled, isLoginSuccess: loginSuccess.asObservable())
    }
    
    
    
}
