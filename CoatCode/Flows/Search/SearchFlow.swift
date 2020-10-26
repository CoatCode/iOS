//
//  SearchFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

class SearchFlow: Flow {

    // MARK: - Properties
    private let services: CoatCodeService

    var root: Presentable {
        return self.rootViewController
    }

    var rootViewController = UIViewController()

    // MARK: - Init
    init(withServices services: CoatCodeService) {
        self.services = services
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? CoatCodeStep else { return .none }

        switch step {
        case .searchIsRequired:
            return navigateToSearch()
        default:
            return .none
        }
    }
}

extension SearchFlow {
    func navigateToSearch() -> FlowContributors {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController.instantiate(withViewModel: viewModel,
                                                              andServices: self.services)

        self.rootViewController.addChild(viewController)
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: viewModel))
    }
}
