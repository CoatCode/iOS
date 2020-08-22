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

class SignInViewModel: ServicesViewModel, Stepper {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var services: CoatCodeService!
    
    let loading = ActivityIndicator()
    var tokenSaved = PublishSubject<Void>()
    
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    
    // MARK: - Struct
    struct Input {
        let signInTrigger: Observable<Void>
    }
    
    struct Output {
        let loginButtonEnabled: Driver<Bool>
    }
}

// MARK: - Transform
extension SignInViewModel {
    func transform(input: Input) -> Output {
        
        let tokenRequest = input.signInTrigger.flatMapLatest {
            return self.services.signIn(email: self.email.value, password: self.password.value.sha256())
                .map(SignIn.self)
                .trackActivity(self.loading)
        }
        
        tokenRequest.subscribe(onNext: { [weak self] response in
            guard let token = response.token else { return }
            AuthManager.setToken(token: token)
            self?.tokenSaved.onNext(())
        }, onError: { error in
            AuthManager.removeToken()
        }).disposed(by: disposeBag)
        
        let profileRequest = tokenSaved.flatMapLatest {
            return self.services.profile()
                .map(User.self)
                .trackActivity(self.loading)
        }
        
        profileRequest.subscribe(onNext: { user in
            // user response값 저장
            
            
            // Stepping (callback to AppStepper)
            loggedIn.accept(true)
        }, onError: { error in
            AuthManager.removeToken()
        }).disposed(by: disposeBag)
        
        let loginButtonEnabled = BehaviorRelay.combineLatest(email, password, self.loading.asObservable()) {
            return !$0.isEmpty && !$1.isEmpty && !$2
        }.asDriver(onErrorJustReturn: false)
        
        return Output(loginButtonEnabled: loginButtonEnabled)
    }
}
