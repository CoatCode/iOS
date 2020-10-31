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
        return rootViewController!
    }

    private weak var rootViewController: UITabBarController?
    private let services: CoatCodeService

    init(tabBarController: UITabBarController, withServices services: CoatCodeService) {
        self.rootViewController = tabBarController
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
        case .uploadPostIsRequired:
            return navigateToUploadPost()
        case .uploadProductIsRequired:
            return navigateToUploadProduct()
        default:
            return .none
        }
    }
}

// MARK: - Navigate to TabBar
extension TabBarFlow {
    private func navigateToTabBar() -> FlowContributors {
        let feedFlow = FeedFlow(withServices: self.services)
        let storeFlow = StoreFlow(withServices: self.services)
        let uploadFlow = UploadFlow(withServices: self.services)
        let favoriteFlow = FavoriteFlow(withServices: self.services)
        let settingFlow = SettingFlow(withServices: self.services)

        Flows.use(feedFlow, storeFlow, uploadFlow, favoriteFlow, settingFlow, when: .created) { [unowned self] (root1, root2, root3, root4, root5: UINavigationController) in

            let tabBarItem1 = UITabBarItem(title: nil, image: UIImage(named: "Feed_Icon"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: nil, image: UIImage(named: "Store_Icon"), selectedImage: nil)
            let tabBarItem3 = UITabBarItem(title: nil, image: UIImage(named: "Writing_Icon"), selectedImage: nil)
            let tabBarItem4 = UITabBarItem(title: nil, image: UIImage(named: "Favorites_Icon"), selectedImage: nil)
            let tabBarItem5 = UITabBarItem(title: nil, image: UIImage(named: "Settings_Icon"), selectedImage: nil)
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

            self.rootViewController?.setViewControllers([root1, root2, root3, root4, root5], animated: true)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: feedFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.feedHomeIsRequired)),
            .contribute(withNextPresentable: storeFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.storeHomeIsRequired)),
            .contribute(withNextPresentable: uploadFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.uploadIsRequired)),
            .contribute(withNextPresentable: favoriteFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.favoritesHomeIsRequired)),
            .contribute(withNextPresentable: settingFlow,
                        withNextStepper: OneStepper(withSingleStep: CoatCodeStep.settingHomeIsRequired))
        ])
    }
}

// MARK: - Navigate to UploadPost
extension TabBarFlow {
    func navigateToUploadPost() -> FlowContributors {
        let viewModel = UploadPostViewModel()
        let viewController = UploadPostViewController.instantiate(withViewModel: viewModel, andServices: self.services)

        viewController.modalPresentationStyle = .fullScreen
        self.rootViewController?.present(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}

// MARK: - Navigate to UploadProduct
extension TabBarFlow {
    func navigateToUploadProduct() -> FlowContributors {
        let viewModel = UploadProductViewModel()
        let viewController = UploadProductViewController.instantiate(withViewModel: viewModel, andServices: self.services)

        viewController.modalPresentationStyle = .fullScreen
        self.rootViewController?.present(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}
