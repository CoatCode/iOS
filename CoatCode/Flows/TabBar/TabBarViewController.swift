//
//  TabBarView.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

class TabBarViewController: UITabBarController, Stepper {

    let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.steps.accept(CoatCodeStep.tabBarIsRequired)
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.children.first!.isKind(of: UploadViewController.self) {

            self.showAlert(title: "무엇이 하고 싶은가요?", message: nil, style: .actionSheet,
                           actions: [
                            AlertAction.action(title: "Upload My Design"),
                            AlertAction.action(title: "Sell My Design"),
                            AlertAction.action(title: "Cancel", style: .cancel)
                           ]
            ).subscribe(onNext: { selectedIndex in
                switch selectedIndex {
                case 0:
                    self.steps.accept(CoatCodeStep.uploadPostIsRequired)
                case 1:
                    self.steps.accept(CoatCodeStep.uploadProductIsRequired)
                default:
                    break
                }
            }).disposed(by: disposeBag)

            return false
        }
        return true
    }
}
