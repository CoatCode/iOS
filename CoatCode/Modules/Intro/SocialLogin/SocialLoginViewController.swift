//
//  SocialLoginViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/10.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class SocialLoginViewController: BaseViewController, StoryboardSceneBased {
    
    // MARK: - Properties
    static let sceneStoryboard = UIStoryboard(name: "Intro" , bundle: nil)
    
    @IBOutlet weak var dismissButton: UIButton!
    
    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? SocialLoginViewModel else { fatalError("ViewModel Casting Falid!") }
            
        dismissButton.rx.tap
            .subscribe(onNext: {
                viewModel.dismiss()
            }).disposed(by: disposeBag)
    }
}
