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
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
}

// MARK: - BindViewModel
extension CreateProfileViewController {
    func bindViewModel() {
        
        let imageObs: Observable<UIImage?> = self.profileImageView.rx.observe(UIImage.self, "image")
        let defaultImage = UIImage(named: "defaultImage")!
        let imageWithDefaultObs: Observable<UIImage> = imageObs.map {
            return $0 ?? defaultImage
        }
        
        imageWithDefaultObs
            .bind(to: viewModel.profileImage)
            .disposed(by: disposeBag)
        
        let input = CreateProfileViewModel.Input(signUpTrigger: signUpButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        
        
        
        
        
        
    }
    
    
    
}

// MARK: - BindImagePicker
extension CreateProfileViewController {
    func bindImagePicker() {
        
        cell.addImageView.isUserInteractionEnabled = true
        cell.addImageView.tag = row //
        cell.addImageView.rx.tapGesture().subscribe(onNext: { (_) in
            print("TAP: \(item.firstName) \(item.lastName)")
        }).disposed(by: cell.bag)
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.rx.tapGesture().subscribe
        
        
        galleryButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }.flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }.take(1)
        }.map { info in
            return info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
    }
    
    
    
    
}
