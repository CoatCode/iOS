//
//  LoginViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: SignInViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = SignInViewModel(authentication: <#T##Authentication#>)
    }
    
    private func bindViewModel() {
        self.emailField.rx.text.orEmpty
            .bind(to: self.viewModel.emailAddress)
            .disposed(by: disposeBag)
        
        
        
        
    }

    
    
}
