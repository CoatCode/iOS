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
    
    static let sceneStoryboard = UIStoryboard(name: "Intro" , bundle: nil)
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindUI()
    }
    
    func bindUI() {
        
        completeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.complete()
            }).disposed(by: disposeBag)
        
    }
    

}
