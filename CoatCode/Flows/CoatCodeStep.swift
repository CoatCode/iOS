//
//  CoatCodeStep.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/14.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow

enum CoatCodeStep: Step {
    
    case tabBarIsRequired
    case introIsRequired
    
    // Intro
    case socialLoginIsRequired
    case emailSignInIsRequired
    case emailSignUpIsRequired
    case socialLoginIsComplete
    case createProfileIsRequired(withViewModel: SignUpViewModel)
    
}
