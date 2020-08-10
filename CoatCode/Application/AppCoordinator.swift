//
//  AppCoordinator.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator {
    
    static let shared = AppCoordinator()
    
    private override init() {}
    
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        self.navigationController.navigationBar.isHidden = true
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
        if loggedIn.value {
            print("Go To Main")
        } else {
            let coordinator = IntroCoordinator()
            coordinator.navigationController = self.navigationController
            self.start(coordinator: coordinator)
        }
    }
    
    func didSignIn() {
//        let coordinator = MainCoordinator()
//        coordinator.navigationController = self.navigationController
//        self.start(coordinator: coordinator)
    }
}
