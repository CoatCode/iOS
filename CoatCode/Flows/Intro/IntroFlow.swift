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
    
    private let services: CoatCodeService
    
    var root: Presentable {
        return self.rootViewController
    }
    
//    let rootViewController = UINavigationController()
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    init(withServices services: CoatCodeService) {
        self.services = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CoatCodeStep else { return .none }
        
        switch step {
            // 첫 인트로 화면
        case .introIsRequired:
            return navigateToIntro()
            // 소셜 로그인 화면
        case .socialLoginIsRequired:
            return navigationToSocialLogin()
            // 이메일 로그인 화면
        case .emailSignInIsRequired:
            return navigationToEmailSignIn()
            // 이메일 회원가입 화면
        case .emailSignUpIsRequired:
            return navigationToEmailSignUp()
            // 프로필 생성 화면
        case .createProfileIsRequired(let viewModel):
            return navigationToCreateProfile(with: viewModel)
            // 소셜 로그인 dismiss
        case .socialLoginIsComplete:
            return dismissSocialLogin()
        default:
            return .none
        }
    }
    
    private func navigateToIntro() -> FlowContributors {
        let introViewController = IntroViewController.instantiate()
        introViewController.title = "Login"
        self.rootViewController.pushViewController(introViewController, animated: false)
        return .one(flowContributor: .contribute(withNext: introViewController))
    }
    
    private func navigationToSocialLogin() -> FlowContributors {
        let socialLoginViewModel = SocialLoginViewModel()
        let socialLoginViewController = SocialLoginViewController.instantiate(withViewModel: socialLoginViewModel)
        
        self.rootViewController.present(socialLoginViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: socialLoginViewController,
                                                 withNextStepper: socialLoginViewModel))
    }
    
    private func navigationToEmailSignIn() -> FlowContributors {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController.instantiate(withViewModel: signInViewModel)
        signInViewController.title = "SignIn"
        
        self.rootViewController.pushViewController(signInViewController, animated: true)
//        self.rootViewController.setNavigationBarHidden(false, animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: signInViewController,
                                                 withNextStepper: signInViewModel))
    }
    
    private func navigationToEmailSignUp() -> FlowContributors {
        let signUpViewModel = SignUpViewModel()
        let signUpViewControlelr = SignUpViewController.instantiate(withViewModel: signUpViewModel)
        
        self.rootViewController.pushViewController(signUpViewControlelr, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: signUpViewControlelr,
                                                 withNextStepper: signUpViewModel))
    }
    
    private func navigationToCreateProfile(with viewModel: SignUpViewModel) -> FlowContributors {
        let createProfileViewController = CreateProfileViewController.instantiate(withViewModel: viewModel, andServices: self.services)
        
        self.rootViewController.pushViewController(createProfileViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: createProfileViewController,
                                                 withNextStepper: viewModel))
    }
    
    private func dismissSocialLogin() -> FlowContributors {
        if let socialLoginViewController = self.rootViewController.presentedViewController {
            socialLoginViewController.dismiss(animated: true)
        }
        return .none
    }
}
