//
//  SettingsViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import Reusable

class SettingsViewController: UIViewController, StoryboardSceneBased, ViewModelBased {

    static let sceneStoryboard = UIStoryboard(name: "Main" , bundle: nil)
    
    var services: CoatCodeService!
    var viewModel: SettingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// MARK: - BindViewModel
extension SettingsViewController {
    func bindViewModel() {
        
    }
}
