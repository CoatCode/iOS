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

class SignInViewController: BaseViewController, StoryboardSceneBased {

    // MARK: - Properties
    static let sceneStoryboard = R.storyboard.intro()

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgetPwButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        backBarButton()
    }

    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = viewModel as? SignInViewModel else { fatalError("ViewModel Casting Falid!") }

        let input = SignInViewModel.Input(signInTrigger: signInButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        emailField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)

        passwordField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)

        output.loginButtonEnabled
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
