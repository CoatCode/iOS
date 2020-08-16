//
//  TabBarFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/15.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxFlow

class TabBarFlow: Flow {
    
    let rootViewController = UITabBarController()
    private let services: CoatCodeService
    
    var root: Presentable {
        return self.rootViewController
    }
    
    init(withServices services: CoatCodeService) {
        self.services = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CoatCodeStep else { return .none }
        
        switch step {
        case .tabBarIsRequired:
            return navigateToTabBar()
        default:
            return .none
        }
    }
    
    private func navigateToTabBar() -> FlowContributors {
        // stepper
        
        let feedFlow = FeedFlow(withServices: self.services)
        let storeFlow = StoreFlow(withServices: self.services)
        let writingFlow = WritingFlow(withServices: self.services)
        let favoriteFlow = FavoriteFlow(withServices: self.services)
        let settingFlow = SettingFlow(withServices: self.services)
        
        Flows.use(feedFlow, storeFlow, writingFlow, favoriteFlow, settingFlow, when: .created) { [unowned self] (root1, root2, root3, root4, root5 : UINavigationController) in
            
            let tabBarItem1 = UITabBarItem()
            let tabBarItem2 = UITabBarItem()
            let tabBarItem3 = UITabBarItem()
            let tabBarItem4 = UITabBarItem()
            let tabBarItem5 = UITabBarItem()
            root1.tabBarItem = tabBarItem1
            root1.title = "Feed"
            root2.tabBarItem = tabBarItem2
            root2.title = "Store"
            root3.tabBarItem = tabBarItem3
            root3.title = "Writing"
            root4.tabBarItem = tabBarItem4
            root4.title = "Favorite"
            root5.tabBarItem = tabBarItem5
            root5.title = "Setting"
            
            self.rootViewController.setViewControllers([root1, root2, root3, root4, root5], animated: false)
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: feedFlow,
                                                        withNextStepper: ),
                                            .contribute(withNextPresentable: storeFlow,
                                                        withNextStepper: ),
                                            .contribute(withNextPresentable: writingFlow,
                                                        withNextStepper: ),
                                            .contribute(withNextPresentable: favoriteFlow,
                                                        withNextStepper: ),
                                            .contribute(withNextPresentable: settingFlow,
                                                        withNextStepper: )])
        
    }
}
