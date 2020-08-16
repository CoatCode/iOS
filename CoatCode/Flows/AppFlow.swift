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
    
    private let services: CoatCodeService
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    init(services: CoatCodeService) {
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
        case .tabBarIsRequired:
            return navigationToTabBar()
        default:
            return .none
        }
    }
    
    private func navigationToTabBar() -> FlowContributors {
        let tabBarFlow = TabBarFlow(withServices: self.services)
        
        Flows.use(tabBarFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: false)
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: tabBarFlow,
                                                 withNextStepper: OneStepper(withSingleStep: CoatCodeStep.tabBarIsRequired)))
    }
    
    private func navigationToIntro() -> FlowContributors {
        let introFlow = IntroFlow(withServices: self.services)
        
        Flows.use(introFlow, when: .created) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: false)
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: introFlow,
                                                 withNextStepper: OneStepper(withSingleStep: CoatCodeStep.introIsRequired)))
    }
}

// 앱 시작시 로그인 유무를 확인하여 TabBar화면을 표시할지, Intro화면을 표시할지를 정한다.
// 로그인 성공시, TabBar화면을 표시해야함.
class AppStepper: Stepper {
    
    let steps = PublishRelay<Step>()
    private let appServices: CoatCodeService

    init(withServices services: CoatCodeService) {
        self.appServices = services
    }

    var initialStep: Step {
        return CoatCodeStep.introIsRequired // Intro화면을 초기 화면으로 표시하고, 로그인이 되어있을경우 TabBar화면을 띄운다.
    }

    // Intro화면이 띄워진 후, 로그인 여부를 확인하여 TabBar화면(main)을 띄우거나 그대로 유지한다.
    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
    func readyToEmitSteps() {
        if loggedIn.value {
            steps.accept(CoatCodeStep.tabBarIsRequired)
        } else {
            steps.accept(CoatCodeStep.logoutIsRequired)
        }
    }
}
