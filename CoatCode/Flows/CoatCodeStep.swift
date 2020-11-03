//
//  CoatCodeStep.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/14.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow

enum CoatCodeStep: Step {

    // MARK: - App
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
    case profileIsRequired(user: User)

    case postDetailIsRequired(cellViewModel: PostCellViewModel)
    case productDetailIsRequired(productId: Int)

    // MARK: - Search
    case searchIsRequired

    // MARK: - Feed
    case feedHomeIsRequired

    // MARK: - Store
    case storeHomeIsRequired

    // MARK: - Upload
    case uploadIsRequired
    case uploadPostIsRequired
    case uploadProductIsRequired

    // MARK: - Favorites
    case favoritesHomeIsRequired

    // MARK: - Setting
    case settingHomeIsRequired

}
