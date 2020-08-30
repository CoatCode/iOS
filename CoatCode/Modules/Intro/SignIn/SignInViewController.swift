//
//  LoginViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class SignInViewController: ViewController, StoryboardSceneBased {
    
    // MARK: - Properties
    static let sceneStoryboard = UIStoryboard(name: "Intro" , bundle: nil)
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var forgetPwButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? SignInViewModel else { fatalError("FatalError!") }
        
        let input = SignInViewModel.Input(signInTrigger: signInButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        emailField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        output.loginButtonEnabled
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure UI
extension SignInViewController {
    private func configureUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BT_LeftArrow"), style: .plain, target: self, action: #selector(popView))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}
