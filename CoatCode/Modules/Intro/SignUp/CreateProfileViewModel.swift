//
//  CreateProfileViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/22.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import Reusable

class CreateProfileViewModel: ServicesBaseViewModel {
    
    // MARK: - Properties
    let profileImage = BehaviorRelay(value: UIImage())
    let buttonStatus = BehaviorRelay(value: false)
    
    let email: String
    let password: String
    let username = BehaviorRelay(value: "")
    
    // MARK: - Init
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    // MARK: - Struct
    struct Input {
        let signUpTrigger: Observable<Void>
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
        let signUpRequest = input.signUpTrigger
            .flatMapLatest { _ -> Observable<Void> in
                let imageData = self.profileImage.value.jpegData(compressionQuality: 1)
                let imageBase64String = imageData?.base64EncodedString()
                
                return self.services.signUp(email: self.email,
                                            password: self.password,
                                            userName: self.username.value,
                                            profile: imageBase64String ?? "")
                    .trackActivity(self.loading)
        }
        
        signUpRequest.subscribe(onNext: { [weak self] in
            print("SignUp Success")
            self?.steps.accept(CoatCodeStep.createProfileIsComplete)
        }, onError: { [weak self] error in
            self?.error.onNext(error as! ResponseError)
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
