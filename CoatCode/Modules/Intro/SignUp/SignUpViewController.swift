//
//  SignUpViewController.swift
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

class SignUpViewController: UIViewController, StoryboardSceneBased, ViewModelBased {
    
    static let sceneStoryboard = UIStoryboard(name: "Intro" , bundle: nil)
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
}

// MARK: - BindViewModel
extension SignUpViewController {
    func bindViewModel() {
        let emailControlEvents: Observable<Bool> = Observable.merge([
            emailField.rx.controlEvent(.editingDidBegin).map { true },
            emailField.rx.controlEvent(.editingDidEnd).map { false }
        ])
        
        let passwordControlEvents: Observable<Bool> = Observable.merge([
            passwordField.rx.controlEvent(.editingDidBegin).map { true },
            passwordField.rx.controlEvent(.editingDidEnd).map { false }
        ])
        
        let input = SignUpViewModel.Input(nextTrigger: nextButton.rx.tap.asDriver(),
                                          emailEvents: emailControlEvents,
                                          passwordEvents: passwordControlEvents)
        let output = viewModel.transform(input: input)
        
        emailField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        output.nextButtonEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.emailValidation
            .drive(self.emailValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordValidation
            .drive(self.passwordValidationLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
