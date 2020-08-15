//
//  AppDelegate.swift
//  CoatCode
//
//  Created by 강민석 on 2020/06/28.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    lazy var appService = {
        return CoatCodeService.shared
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let window = self.window else { return false }

        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)

        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)

        let appFlow = AppFlow(services: self.appServices)
        let appStepper = AppStepper(withServices: self.appServices)

        self.coordinator.coordinate(flow: appFlow, with: appStepper)

        Flows.use(appFlow, when: .created) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
        return true
    }
    

}

