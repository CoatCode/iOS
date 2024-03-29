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
        case .profileIsRequired(let user):
            return navigateToProfile(with: user)
        case .searchIsRequired:
            return navigateToSearch()
        case .postDetailIsRequired(let cellViewModel):
            return navigateToPostDetail(with: cellViewModel)
        case .likesIsRequired(let postId):
            return navigateToLikes(postId: postId)
        case .popViewIsRequired:
            self.rootViewController.popViewController(animated: true)
            return .none
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
    private func navigateToProfile(with user: User) -> FlowContributors {
        let viewModel = ProfileViewModel(user: user)
        let viewController = ProfileViewController.instantiate(withViewModel: viewModel,
                                                               andServices: self.services)

        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}

// MARK: - Navigate to Search
extension FeedFlow {
    private func navigateToSearch() -> FlowContributors {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController.instantiate(withViewModel: viewModel, andServices: self.services)

        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}

// MARK: - Navigate to Post(Feed) Detail
extension FeedFlow {
    private func navigateToPostDetail(with cellViewModel: PostCellViewModel) -> FlowContributors {
        let viewModel = PostDetailViewModel(with: cellViewModel)
        let viewController = PostDetailViewController.instantiate(withViewModel: viewModel, andServices: self.services)

        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}

// MARK: - Navigate to Search Result
extension FeedFlow {

}

// MARK: - Navigate to Likes
extension FeedFlow {
    private func navigateToLikes(postId: Int) -> FlowContributors {
        let viewModel = LikesViewModel(with: postId)
        let viewController = LikesViewController.instantiate(withViewModel: viewModel, andServices: self.services)

        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}
