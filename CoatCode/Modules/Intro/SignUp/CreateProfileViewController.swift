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
        
        let input = CreateProfileViewModel.Input(signUpTrigger: signUpButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        
        
        
        
    }
    
    
}
