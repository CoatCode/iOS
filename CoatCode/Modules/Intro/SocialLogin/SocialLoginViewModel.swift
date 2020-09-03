//
//  SocialLoginViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/17.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class SocialLoginViewModel: BaseViewModel {

    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    func dismiss() {
        steps.accept(CoatCodeStep.socialLoginIsComplete)
    }
}
