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
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var emailSignupButton: UIButton!
    
    var steps: PublishRelay<Step>
    
    let disposeBag = DisposeBag()
    var viewModel: IntroViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
