//
//  WritingFlow.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/16.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit

class WritingFlow: Flow {
    
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
        case .writingHomeIsRequired:
            return navigateToWriting()
        default:
            return .none
        }
    }
}

// MARK: - Navigate to Writing
extension WritingFlow {
    func navigateToWriting() -> FlowContributors {
        let viewModel = WritingViewModel()
        let viewController = WritingViewController.instantiate(withViewModel: viewModel,
                                                               andServices: self.services)
        
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
    
}
