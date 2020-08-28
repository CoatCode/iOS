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
import RxFlow
import RxGesture

class CreateProfileViewController: UIViewController, StoryboardSceneBased, ViewModelBased {
    
    // MARK: - Properties
    static let sceneStoryboard = UIStoryboard(name: "Intro" , bundle: nil)
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: CreateProfileViewModel!
    
    let isLoading = BehaviorRelay(value: false)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindImagePicker()
        
        setProfileImageView()
        configureUI()
    }
}

// MARK: - BindViewModel
extension CreateProfileViewController {
    func bindViewModel() {
        
        let nameControlEvents: Observable<Bool> = Observable.merge([
            nameField.rx.controlEvent(.editingDidBegin).map { true },
            nameField.rx.controlEvent(.editingDidEnd).map { false }
        ])
        
        let input = CreateProfileViewModel.Input(signUpTrigger: signUpButton.rx.tap.asObservable(),
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
    func bindImagePicker() {
        
        let imagePicker = imagePickerScene(
            on: self,
            modalPresentationStyle: .formSheet,
            modalTransitionStyle: .none
        )

        profileImageView.rx.tapGesture()
            .flatMapLatest { _ in Observable.create(imagePicker) }
            .compactMap { $0[.originalImage] as? UIImage }
            .bind { image in
                self.profileImageView.clipsToBounds = true
                self.profileImageView.image = image
                self.viewModel.profileImage.accept(image)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure UI
extension CreateProfileViewController {
    private func configureUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BT_LeftArrow"), style: .plain, target: self, action: #selector(popView))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setProfileImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.clipsToBounds = true
        
        self.profileImageView.image = UIImage(named: "user")
        viewModel.profileImage.accept(UIImage(named: "user")!)
    }
}
