//
//  FavoriteFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/16.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit

class FavoriteFlow: Flow {
    
    // MARK: - Properties
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
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
        case . favoritesHomeIsRequired:
            return navigateToFavorites()
        default:
            return .none
        }
        
    }
    
}

// MARK: - Navigate to Favorites
extension FavoriteFlow {
    func navigateToFavorites() -> FlowContributors {
        let viewModel = FavoritesViewModel()
        let viewController = FavoritesViewController.instantiate(withViewModel: viewModel,
                                                                 andServices: self.services)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
}
