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

class SignUpViewModel: Stepper, ServicesViewModel {
    
    var steps = PublishRelay<Step>()
    var services: CoatCodeService!
        
    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")
    
    func next() {
        steps.accept(CoatCodeStep.createProfileIsRequired(withViewModel: self))
    }
    
    func complete() {
//        steps.accept()
    }
    
}
