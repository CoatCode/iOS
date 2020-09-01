//
//  AppFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/14.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {
    
    // MARK: - Properties
    private let window: UIWindow
    private let services: CoatCodeService
    
    // dummy
    var root: Presentable {
        return UIViewController()
    }
    
    // MARK: - Init
    init(window: UIWindow, services: CoatCodeService) {
        self.window = window
        self.services = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CoatCodeStep else { return .none }
        
        switch step {
        case .introIsRequired:
            return navigateToIntro()
        case .tabBarIsRequired:
            return navigationToTabBar()
        default:
            return .none
        }
    }
}

// MARK: - Navigate to TabBar
extension AppFlow {
    private func navigationToTabBar() -> FlowContributors {
        let tabBarFlow = TabBarFlow(withServices: self.services)
        
        Flows.use(tabBarFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
            
            UIView.transition(with: self.window,
                              duration: 0.5,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: tabBarFlow,
                                                 withNextStepper: OneStepper(withSingleStep: CoatCodeStep.tabBarIsRequired)))
    }
}

// MARK: - Navigate to Intro
extension AppFlow {
    private func navigateToIntro() -> FlowContributors {
        let introFlow = IntroFlow(withServices: self.services)
        
        Flows.use(introFlow, when: .created) { [unowned self] root in
            self.window.rootViewController = root
            
            UIView.transition(with: self.window,
                              duration: 0.5,
                              options: [.transitionCrossDissolve],
                              animations: nil,
                              completion: nil)
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: introFlow,
                                                 withNextStepper: OneStepper(withSingleStep: CoatCodeStep.introIsRequired)))
    }
}

// 앱 시작시 로그인 유무를 확인하여 TabBar화면을 표시할지, Intro화면을 표시할지를 정한다.
// 로그인 성공시, TabBar화면을 표시해야함.
class AppStepper: Stepper {
    
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    // 로그인 여부를 확인하여 Intro화면을 보여줄지 TabBar화면(main)을 줄지를 결정한다.
    var initialStep: Step {
        let isLogin = UserDefaults.standard.bool(forKey: "loginState")
        if isLogin {
            return CoatCodeStep.tabBarIsRequired
        } else {
            return CoatCodeStep.introIsRequired
        }
    }
    
    // 로그인 성공시 실행되는 콜백 메서드
    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
    func readyToEmitSteps() {
        loggedIn
            .subscribe(onNext: { [weak self] isLogin in
                if isLogin {
                    self?.steps.accept(CoatCodeStep.tabBarIsRequired)
                }
            }).disposed(by: disposeBag)
    }
}
