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
    
    // MARK: - Intro
    case socialLoginIsRequired
    case emailSignInIsRequired
    case emailSignUpIsRequired
    case socialLoginIsComplete
    case createProfileIsRequired(email: String, password: String)
    case createProfileIsComplete
    
    // MARK: - Profile
    case profileIsRequired(uesrId: Int)
    
    case postDetailIsRequired(postId: Int)
    case productDetailIsRequired(productId: Int)
    
    // MARK: - Feed
    case feedHomeIsRequired
    
    // MARK: - Store
    case storeHomeIsRequired
    
    // MARK: - Writing
    case writingHomeIsRequired
//    case postIsRequired
//    case productIsRequired
    
    // MARK: - Favorites
    case favoritesHomeIsRequired
    
    // MARK: - Setting
    case settingHomeIsRequired
    
    
}
