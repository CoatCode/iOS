//
//  IntroFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/16.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import UIKit
import RxFlow

class IntroFlow: Flow {

    // MARK: - Properties
    private let services: CoatCodeService

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        // Navigation Bar를 transparent하게
        viewController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        viewController.navigationBar.shadowImage = UIImage()
        viewController.navigationBar.isTranslucent = true
        return viewController
    }()

    // MARK: - Init
    init(withServices services: CoatCodeService) {
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CoatCodeStep else { return .none }

        switch step {
        // 첫 인트로 화면
        case .introIsRequired:
            return navigateToIntro()
        // 소셜 로그인 화면
        case .socialLoginIsRequired:
            return navigateToSocialLogin()
        // 이메일 로그인 화면
        case .emailSignInIsRequired:
            return navigateToEmailSignIn()
        // 이메일 회원가입 화면
        case .emailSignUpIsRequired:
            return navigateToEmailSignUp()
        // 프로필 생성 화면
        case .createProfileIsRequired(let email, let password):
            return navigateToCreateProfile(email: email, password: password)
        // 소셜 로그인 dismiss
        case .socialLoginIsComplete:
            return dismissSocialLogin()
        case .createProfileIsComplete:
            return popToRootView()
        default:
            return .none
        }
    }
}

// MARK: - Navigate to Intro
extension IntroFlow {
    private func navigateToIntro() -> FlowContributors {
        let introViewController = IntroViewController.instantiate()

        self.rootViewController.pushViewController(introViewController, animated: false)
        return .one(flowContributor: .contribute(withNext: introViewController))
    }
}

// MARK: - Navigate to SocialLogin
extension IntroFlow {
    private func navigateToSocialLogin() -> FlowContributors {
        let socialLoginViewModel = SocialLoginViewModel()
        let socialLoginViewController = SocialLoginViewController.instantiate(withViewModel: socialLoginViewModel)

        self.rootViewController.present(socialLoginViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: socialLoginViewController,
                                                 withNextStepper: socialLoginViewModel))
    }
}

// MARK: - Navigate to EmailSignIn
extension IntroFlow {
    private func navigateToEmailSignIn() -> FlowContributors {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController.instantiate(withViewModel: signInViewModel,
                                                                    andServices: self.services)

        self.rootViewController.pushViewController(signInViewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: signInViewController,
                                                 withNextStepper: signInViewModel))
    }
}

// MARK: - Navigate to EmailSignUp
extension IntroFlow {
    private func navigateToEmailSignUp() -> FlowContributors {
        let signUpViewModel = SignUpViewModel()
        let signUpViewControlelr = SignUpViewController.instantiate(withViewModel: signUpViewModel)

        self.rootViewController.pushViewController(signUpViewControlelr, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: signUpViewControlelr,
                                                 withNextStepper: signUpViewModel))
    }
}

// MARK: - Navigate to CreateProfile
extension IntroFlow {
    private func navigateToCreateProfile(email: String, password: String) -> FlowContributors {
        let createProfileViewModel = CreateProfileViewModel(email: email, password: password)
        let createProfileViewController = CreateProfileViewController.instantiate(withViewModel: createProfileViewModel,
                                                                                  andServices: self.services)

        self.rootViewController.pushViewController(createProfileViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: createProfileViewController,
                                                 withNextStepper: createProfileViewModel))
    }
}

// MARK: - Dismiss SocialLogin
extension IntroFlow {
    private func dismissSocialLogin() -> FlowContributors {
        if let socialLoginViewController = self.rootViewController.presentedViewController {
            socialLoginViewController.dismiss(animated: true)
        }
        return .none
    }
}

// MARK: - Dismiss to RootViewController
extension IntroFlow {
    private func popToRootView() -> FlowContributors {
//        if let createProfileViewController = rootViewController.presentedViewController {
//            createProfileViewController.
//        }
        self.rootViewController.popToRootViewController(animated: true)
        return .none
    }
}
