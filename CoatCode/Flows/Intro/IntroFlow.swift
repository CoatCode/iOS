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
        case .introIsRequired:
            return navigationToIntro()
        case .socialLoginIsRequired:
            return navigationToSocialLogin()
        case .emailSignInIsRequired:
            return navigationToEmailSignIn()
        case .emailSignUpIsRequired:
            return navigationToEmailSignUp()
        case .socialLoginIsComplete:
            return dismissSocialLogin()
        default:
            return .none
        }
    }
    
    private func navigationToIntro() -> FlowContributors {
        let introViewController = IntroViewController.instantiate()
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
        
        self.rootViewController.pushViewController(signInViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: signInViewController,
                                                 withNextStepper: signInViewModel))
    }
    
    private func navigationToEmailSignUp() -> FlowContributors {
        let signUpViewModel = SignUpViewModel()
        let signUpViewControlelr = SignUpViewController.instantiate(withViewModel: signUpViewModel)
        
        self.rootViewController.pushViewController(signUpViewControlelr, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: , withNextStepper: ))
    }
    
    private func dismissSocialLogin() -> FlowContributors {
        if let socialLoginViewController = self.rootViewController.presentedViewController {
            socialLoginViewController.dismiss(animated: true)
        }
    }
}
