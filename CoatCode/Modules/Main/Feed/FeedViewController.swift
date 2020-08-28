//
//  FeedViewController.swift
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

class FeedViewController: UIViewController, StoryboardSceneBased, ViewModelBased {

    static let sceneStoryboard = UIStoryboard(name: "Main" , bundle: nil)
    
    var services: CoatCodeService!
    var viewModel: FeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
}

// MARK: - BindViewModel
extension FeedViewController {
    func bindViewModel() {
        
    }
}
