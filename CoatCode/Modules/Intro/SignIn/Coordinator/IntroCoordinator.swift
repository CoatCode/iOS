//
//  IntroCoordinator.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/10.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift

class IntroCoordinator: BaseCoordinator {
    
    private let disposeBag = DisposeBag()
    
    override func start() {
        let viewController = UIStoryboard.init(name: "Intro", bundle: nil).instantiateInitialViewController()
        guard let introViewController = viewController as? IntroViewController  else { return }
        
        let introViewModel = IntroViewModel()
        introViewController.viewModel = introViewModel
        
        introViewModel.signIn
            .subscribe(onNext: { [weak self] in
                self?.showSignIn()
            }).disposed(by: disposeBag)
        
        introViewModel.signUp
            .subscribe(onNext: { [weak self] in
                self?.showSignUp()
            }).disposed(by: disposeBag)
        
        introViewModel.socialLogin
            .subscribe(onNext: { [weak self] in
                self?.showSocialLogin()
            }).disposed(by: disposeBag)
        
        self.navigationController.viewControllers = [introViewController]
    }
    
    func showSignIn() {
        let signInCoordinator = SignInCoordinator()
        
        self.start(coordinator: signInCoordinator)
        
//        let signInViewModel = SignInViewModel()
//        let signInViewContorller = SignInViewController()
//        signInViewContorller.viewModel = signInViewModel
//        navigationController.present(signInViewContorller, animated: true)
    }
    
    func showSignUp() {
        
    }
    
    // present
    func showSocialLogin() {
        
    }
    
    
    
    
}
