//
//  SocialLoginViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/10.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxFlow
import RxSwift
import RxCocoa

class SocialLoginViewController: UIViewController, StoryboardBased, ViewModelBased {
    
    var viewModel: SocialLoginViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindUI() {
        dismissButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.
            }).disposed(by: disposeBag)
    }
}
