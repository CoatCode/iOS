//
//  FeedFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/16.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit

class FeedFlow: Flow {
    
    // MARK: - Properties
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UINavigationController()
    private let services: CoatCodeService
    
    // MARK: - Init
    init(withServices services: CoatCodeService) {
        self.services = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    // MARK: - Navigation Switch
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CoatCodeStep else { return .none }
        
        switch step {
        case .feedHomeIsRequired:
            return navigateToFeed()
        case .profileIsRequired(let userId):
            return navigateToProfile(with: userId)
        default:
            return .none
        }
    }
    
}

// MARK: - Navigate to Feed(Home)
extension FeedFlow {
    private func navigateToFeed() -> FlowContributors {
        let viewModel = FeedViewModel()
        let viewController = FeedViewController.instantiate(withViewModel: viewModel,
                                                            andServices: self.services)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}

// MARK: - Navigate to Profile
extension FeedFlow {
    private func navigateToProfile(with userId: Int) -> FlowContributors {
        let viewModel = ProfileViewModel(userId: userId)
        let viewController = ProfileViewController.instantiate(withViewModel: viewModel,
                                                               andServices: self.services)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}
