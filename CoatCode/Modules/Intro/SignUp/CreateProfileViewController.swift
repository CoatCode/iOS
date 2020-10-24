//
//  CreateProfileViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/10.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxGesture

class CreateProfileViewController: BaseViewController, StoryboardSceneBased {
    
    // MARK: - Properties
    static let sceneStoryboard = R.storyboard.intro()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindProfileImage()
        backBarButton()
        setProfileImageView()
    }

    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? CreateProfileViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let nameControlEvents: Observable<Bool> = Observable.merge([
            nameField.rx.controlEvent(.editingDidBegin).map { true },
            nameField.rx.controlEvent(.editingDidEnd).map { false }
        ])
        
        let input = CreateProfileViewModel.Input(signUpTrigger: signUpButton.rx.tap.asDriver(),
                                                 nameEvents: nameControlEvents)
        let output = viewModel.transform(input: input)
        
        nameField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        output.signUpButtonEnabled
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nameValidation
            .drive(nameValidationLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - BindImagePicker
extension CreateProfileViewController {
    func bindProfileImage() {
        guard let viewModel = viewModel as? CreateProfileViewModel else { fatalError("FatalError!") }
        
        let imagePicker = imagePickerScene(
            on: self,
            modalPresentationStyle: .formSheet,
            modalTransitionStyle: .none
        )

        profileImageView.rx.tapGesture()
            .when(.recognized)
            .flatMapLatest { _ in Observable.create(imagePicker) }
            .compactMap { $0[.originalImage] as? UIImage }
            .bind { image in
                self.profileImageView.clipsToBounds = true
                self.profileImageView.image = image
                viewModel.profileImage.accept(image)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure UI
extension CreateProfileViewController {
    func setProfileImageView() {
        profileImageView.roundCorners(.allCorners, radius: profileImageView.frame.width)
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.clipsToBounds = true
        
        self.profileImageView.image = UIImage(named: "Default_Profile")
    }
}
