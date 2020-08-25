//
//  SignUpViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/18.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModel, Stepper {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    
    let emailValid = BehaviorRelay(value: false)
    let passwordValid = BehaviorRelay(value: false)
    
    // MARK: - Struct
    struct Input {
        let nextTrigger: Driver<Void>
        let emailEvents: Observable<Bool>
        let passwordEvents: Observable<Bool>
    }
    
    struct Output {
        let nextButtonEnabled: Driver<Bool>
        let emailValidation: Driver<String>
        let passwordValidation: Driver<String>
    }
    
    // MARK: - Regular Expression
    func validateEmail(_ string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return string.range(of: emailRegEx, options: .regularExpression) != nil
    }
    
    func validatePassword(text : String, size : (min : Int, max : Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
}

// MARK: - Transform
extension SignUpViewModel {
    func transform(input: Input) -> Output {
        // MARK: - Button Trigger
        input.nextTrigger
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.steps.accept(CoatCodeStep.createProfileIsRequired(email: self.email.value, password: self.password.value))
            }).disposed(by: disposeBag)
        
        // MARK: - Button Status
        let buttonStatus = BehaviorRelay.combineLatest(self.emailValid, self.passwordValid) {
            return $0 && $1
        }.asDriver(onErrorJustReturn: false)
        
        // MARK: - Valid Check
        let isEmailValid = email
            .throttle(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .map { [weak self] text -> Bool in
                guard let isValid = self?.validateEmail(text) else { return false }
                return !text.isEmpty && isValid
        }.distinctUntilChanged()
        
        let isPasswordValid = password
            .throttle(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
                .map { [weak self] text -> Bool in
                    guard let isValid = self?.validatePassword(text: text, size: (8, 15)) else { return false }
                    return !text.isEmpty && isValid
            }.distinctUntilChanged()
        
        // MARK: - Validation Observable
        let emailValidation = Observable.combineLatest(isEmailValid, input.emailEvents).flatMap { [weak self] (isValid: Bool, editingDidEnd: Bool) -> Observable<String> in
            if isValid {
                self?.emailValid.accept(true)
                return Observable.from(optional: "")
            } else if editingDidEnd {
                self?.emailValid.accept(false)
                return Observable.from(optional: "올바르지 않은 이메일입니다.")
            } else {
                self?.emailValid.accept(false)
                return .empty()
            }
        }.distinctUntilChanged()
        
        let passwordValidation = Observable.combineLatest(isPasswordValid, input.passwordEvents).flatMap { [weak self] (isValid: Bool, editingDidEnd: Bool) -> Observable<String> in
            if isValid {
                self?.passwordValid.accept(true)
                return Observable.from(optional: "")
            } else if editingDidEnd {
                self?.passwordValid.accept(false)
                return Observable.from(optional: "8 ~ 15 자리로 구성된 비밀번호를 입력해주세요.")
            } else {
                self?.passwordValid.accept(false)
                return .empty()
            }
        }.distinctUntilChanged()
        
        // MARK: - Return Output
        return Output(nextButtonEnabled: buttonStatus,
                      emailValidation: emailValidation.asDriver(onErrorJustReturn: ""),
                      passwordValidation: passwordValidation.asDriver(onErrorJustReturn: ""))
    }
}
