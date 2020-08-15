//
//  AppFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/14.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow

class AppFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    private let services: AppServices

    init(services: AppServices) {
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CoatCodeStep else { return .none }
        
        switch step {
        case tabBarIsRequired:
            return navigationToTabBar()
        case introIsRequired:
            return navigationToIntro()
        default:
            return .none
        }
    }
    
    private func navigationToTabBar() {
        let tabBarFlow = TabBarFlow()
        
    }
    
    private func navigationToIntro() {
        
    }
    
    
    
    
}

