//
//  LoginViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxFlow
import RxSwift
import RxCocoa

class SignInViewController: UIViewController, StoryboardSceneBased, ViewModelBased {
    
    // MARK: - Properties
    static let sceneStoryboard = UIStoryboard(name: "Intro" , bundle: nil)
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var forgetPwButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: SignInViewModel!
    
    let isLoading = BehaviorRelay(value: false)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configureUI()
    }
}

// MARK: - BindViewModel
extension SignInViewController {
    private func bindViewModel() {
        
        let input = SignInViewModel.Input(signInTrigger: signInButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        viewModel.loading.asObservable().bind(to: self.isLoading).disposed(by: disposeBag)
        
        isLoading.subscribe(onNext: { isLoading in
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }).disposed(by: disposeBag)
        
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
