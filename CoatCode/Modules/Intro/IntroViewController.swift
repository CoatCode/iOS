//
//  IntroViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow

class IntroViewController: UIViewController, StoryboardBased, Stepper {
    
    @IBOutlet weak var socialLoginButton: UIButton!
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var emailSignUpButton: UIButton!
    
    var steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
    }
    
    func bindUI() {
        socialLoginButton.rx.tap
            .map { CoatCodeStep.socialLoginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        emailSignInButton.rx.tap
            .map { CoatCodeStep.emailSignInIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        emailSignUpButton.rx.tap
            .map { CoatCodeStep.emailSignUpIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
}
