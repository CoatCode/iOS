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
        default:
            return .none
        }
    }
    
    private func navigationToIntro() -> FlowContributors {
        let introViewController = IntroViewController.instantiate()
        self.rootViewController.pushViewController(introViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: introViewController))
    }
}
