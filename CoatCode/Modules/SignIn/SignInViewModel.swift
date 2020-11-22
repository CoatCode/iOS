//
//  LoginViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class SignInViewModel: BaseViewModel {

    // MARK: - Properties
    var tokenSaved = PublishSubject<Void>()
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")

    // MARK: - Struct
    struct Input {
        let signInTrigger: Driver<Void>
    }

    struct Output {
        let loginButtonEnabled: Driver<Bool>
    }
}

// MARK: - Transform
extension SignInViewModel {
    func transform(input: Input) -> Output {
        // MARK: - Button Trigger
        input.signInTrigger
            .drive(onNext: {
                self.signInRequest()
            }).disposed(by: disposeBag)

        let loginButtonEnabled = BehaviorRelay.combineLatest(email, password, self.loading.asObservable()) {
            return !$0.isEmpty && !$1.isEmpty && !$2
        }.asDriver(onErrorJustReturn: false)

        return Output(loginButtonEnabled: loginButtonEnabled)
    }
}

// MARK: - Functions
extension SignInViewModel {
    func signInRequest() {
        self.services.signIn(email: self.email.value, password: self.password.value)
            .trackActivity(self.loading)
            .subscribe(
                onNext: { [weak self] response in
                    AuthManager.setToken(token: response)
                    // 프로필 정보 요청
                    self?.profileRequest()
                },
                onError: { [weak self] error in
                    self?.error.onNext(error as! ErrorResponse)
                    AuthManager.removeToken()
            }).disposed(by: disposeBag)
    }

    func profileRequest() {
        return self.services.profile()
            .trackActivity(self.loading)
            .subscribe(
                onNext: { profile in
                    // user response값 저장
                    DatabaseManager.shared.saveUser(profile)

                    // keychain에 username값 저장
                    KeychainManager.shared.username = profile.username

                    // Stepping (callback to AppStepper)
                    UserDefaults.standard.set(true, forKey: "loginState")
                    loggedIn.accept(true)
                },
                onError: { [weak self] error in
                    self?.error.onNext(error as! ErrorResponse)
                    AuthManager.removeToken()
            }).disposed(by: disposeBag)
    }
}
