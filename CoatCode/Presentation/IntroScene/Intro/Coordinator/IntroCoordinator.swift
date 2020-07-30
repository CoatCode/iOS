//
//  IntroCoordinator.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import UIKit

protocol IntroCoordinator: AnyObject {
    func pushToLogin(_ navigationController: UINavigationController)
    func pushToSignup(_ navigationController: UINavigationController)
    func presentView(_ navigationController: UINavigationController)
}

extension IntroCoordinator {
    func pushToLogin(_ navigationController: UINavigationController) {
        let vc = LoginViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToSignup(_ navigationController: UINavigationController) {
        let vc = SignupInputViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentView(_ navigationController: UINavigationController) {
        let vc = SocialLoginViewController()
        navigationController.present(vc, animated: true)
    }
    
}
