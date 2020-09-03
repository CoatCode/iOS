//
//  SignUpViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/10.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class SignUpViewController: ViewController, StoryboardSceneBased {
    
    // MARK: - Properties
    static let sceneStoryboard = UIStoryboard(name: "Intro" , bundle: nil)
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBarButton()
    }

    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? SignUpViewModel else { fatalError("ViewModel Casting Falid!") }
        
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
