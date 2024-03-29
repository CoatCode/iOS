//
//  FavoritesViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class FavoritesViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = R.storyboard.favorites()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = self.viewModel as? FavoritesViewModel else { fatalError("ViewModel Casting Falid!") }

    }

}
