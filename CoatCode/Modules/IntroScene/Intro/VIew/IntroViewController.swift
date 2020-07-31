//
//  IntroViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IntroViewController: UIViewController {

    @IBOutlet weak var socialLoginButton: UIButton!
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var emailSignupButton: UIButton!
    
    let viewModel = IntroViewModel()
    weak var coordinator: IntroCoordinator?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func bindViewModel() {
        socialLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.pushToLogin((self?.navigationController)!)
            }).disposed(by: disposeBag)
    }
    

}
