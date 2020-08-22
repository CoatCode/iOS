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

class CreateProfileViewModel: ServicesViewModel, Stepper {

    // MARK: - Properties
    var steps = PublishRelay<Step>()
    var services: CoatCodeService!
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
        let signUpTrigger: Driver<Void>
    }
    
    struct Output {
        
    }
}

// MARK: - Transform
extension CreateProfileViewModel {
    func transform(input: Input) -> Output {
        
        let profileRequest = input.signUpTrigger.flatMapLatest { [weak self] in
            
            
            return self.services.signUp(email: self?.email, password: self?.password, userName: self?.username, profile: <#T##String#>)
                .map(Void)
                .trackActivity(self.loading)
        }
        
        profileRequest.subscribe(onNext: { [weak self] response in
            guard let self = self = else { return }
            
            
        })
        
        
        return Output()
    }
    
    
    
}
