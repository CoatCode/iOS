//
//  PopularFeedViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/04.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import XLPagerTabStrip

class PopularFeedViewController: BaseViewController, StoryboardSceneBased, IndicatorInfoProvider {
    
    static let sceneStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "인기"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }
        viewModel.filter.accept(FeedFilter.popularContent)
    }
    
}
