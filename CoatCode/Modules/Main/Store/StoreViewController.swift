//
//  StoreViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class StoreViewController: ViewController, StoryboardSceneBased {

    static let sceneStoryboard = UIStoryboard(name: "Main" , bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? StoreViewModel else { fatalError("ViewModel Casting Falid!") }
        
    }
}
