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
            
            let tabBarItem1 = UITabBarItem(title: nil, image: UIImage(named: "FeedIcon"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: nil, image: UIImage(named: "StoreIcon"), selectedImage: nil)
            let tabBarItem3 = UITabBarItem(title: nil, image: UIImage(named: "WritingIcon"), selectedImage: nil)
            let tabBarItem4 = UITabBarItem(title: nil, image: UIImage(named: "FavoritesIcon"), selectedImage: nil)
            let tabBarItem5 = UITabBarItem(title: nil, image: UIImage(named: "SettingsIcon"), selectedImage: nil)
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
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: feedFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.feedHomeIsRequired)),
            .contribute(withNextPresentable: storeFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.storeHomeIsRequired)),
            .contribute(withNextPresentable: writingFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.writingHomeIsRequired)),
            .contribute(withNextPresentable: favoriteFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.favoritesHomeIsRequired)),
            .contribute(withNextPresentable: settingFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.settingHomeIsRequired))
        ])
        
    }
}
