//
//  TabBarFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/15.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import UIKit
import RxFlow

class TabBarFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UITabBarController()
    private let services: CoatCodeService
    
    init(withServices services: CoatCodeService) {
        self.services = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CoatCodeStep else { return .none }
        
        switch step {
        
        default:
            return .none
        }
        
    }
    
    private func navigateToTabBar() -> FlowContributors {
        
        
        
        
        
    }
    
    
    
}
