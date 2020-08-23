//
//  SocialLoginViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/17.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

class SocialLoginViewModel: ServicesViewModel, Stepper {

    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    var steps = PublishRelay<Step>()
    typealias Services = CoatCodeService
    
    var services: Services!
    
    func dismiss() {
        steps.accept(CoatCodeStep.socialLoginIsComplete)
    }
}
