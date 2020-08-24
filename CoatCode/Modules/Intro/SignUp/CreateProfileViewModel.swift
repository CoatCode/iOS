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
import CryptoSwift

class CreateProfileViewModel: ServicesViewModel, Stepper {
    
    // MARK: - Properties
    var steps = PublishRelay<Step>()
    var services: CoatCodeService!
    let disposeBag = DisposeBag()
    let loading = ActivityIndicator()
    
    let email: String
    let password: String
    let username = BehaviorRelay(value: "")
    let profileImage = BehaviorRelay(value: UIImage())
    
    
    // MARK: - Init
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    // MARK: - Struct
    struct Input {
        let signUpTrigger: Observable<Void>
    }
    
    struct Output {
        
    }
}

// MARK: - Transform
extension CreateProfileViewModel {
    func transform(input: Input) -> Output {
        
        let imageData = self.profileImage.value.jpegData(compressionQuality: 1)
        let imageBase64String = imageData?.base64EncodedString()
        
        input.signUpTrigger.flatMapLatest {
            return self.services.signUp(email: self.email,
                                        password: self.password.sha256(),
                                        userName: self.username.value,
                                        profile: imageBase64String ?? "")
                .trackActivity(self.loading)
        }
        .subscribe(onNext: { _ in
            print("asldfkjs;aldkjf")
        }).disposed(by: disposeBag)
        return Output()
    }
}
