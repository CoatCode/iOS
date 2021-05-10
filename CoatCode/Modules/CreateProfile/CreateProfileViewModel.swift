//
//  CreateProfileViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/22.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class CreateProfileViewModel: BaseViewModel {

    // MARK: - Properties
    let profileImage = BehaviorRelay(value: UIImage())
    let buttonStatus = BehaviorRelay(value: false)
    let username = BehaviorRelay(value: "")
    let email: String
    let password: String

    // MARK: - Init
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    // MARK: - Struct
    struct Input {
        let signUpTrigger: Driver<Void>
        let nameEvents: Observable<Bool>
    }

    struct Output {
        let signUpButtonEnabled: Driver<Bool>
        let nameValidation: Driver<String>
    }

    // MARK: - Regular Expression
    func validateName(_ string: String) -> Bool {
        return string.range(of: "^[가-힣]{2,4}+$", options: .regularExpression) != nil
    }
}

// MARK: - Transform
extension CreateProfileViewModel {
    func transform(input: Input) -> Output {

        // MARK: - Button Trigger
        input.signUpTrigger
            .drive(onNext: { [weak self] in
                self?.signUpRequest()
            }).disposed(by: disposeBag)

        // MARK: - Valid Check
        let isNameValid = username
            .throttle(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .map { [weak self] text -> Bool in
                guard let isValid = self?.validateName(text) else { return false }
                return !text.isEmpty && isValid
        }.distinctUntilChanged()

        // MARK: - Validation Observable
        let nameValidation = Observable.combineLatest(isNameValid, input.nameEvents).flatMap { [weak self] (isValid: Bool, editingDidEnd: Bool) -> Observable<String> in
            if isValid {
                self?.buttonStatus.accept(true)
                return Observable.from(optional: " ")
            } else if editingDidEnd {
                self?.buttonStatus.accept(false)
                return Observable.from(optional: "올바르지 않은 이름 형식입니다.")
            } else {
                self?.buttonStatus.accept(false)
                return .empty()
            }
        }.distinctUntilChanged()

        // MARK: - Return Output
        return Output(signUpButtonEnabled: buttonStatus.asDriver(onErrorJustReturn: false),
                      nameValidation: nameValidation.asDriver(onErrorJustReturn: ""))
    }
}

// MARK: - Functions
extension CreateProfileViewModel {
    func signUpRequest() {
        return self.services.signUp(email: self.email,
                                password: self.password,
                                username: self.username.value,
                                image: self.profileImage.value)
        .trackActivity(self.loading)
        .subscribe(onNext: { [weak self] in
            self?.steps.accept(CoatCodeStep.createProfileIsComplete)
            }, onError: { [weak self] error in
                self?.error.onNext(error as! ErrorResponse)
        }).disposed(by: self.disposeBag)
    }
}
