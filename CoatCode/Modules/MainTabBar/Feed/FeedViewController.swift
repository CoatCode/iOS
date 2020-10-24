//
//  FeedViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import XLPagerTabStrip
import RxGesture

class FeedViewController: CustomTabBarViewController, StoryboardSceneBased {

    // MARK: - Properties
    static let sceneStoryboard = R.storyboard.feed()
    
    @IBOutlet weak var feedTableView: UITableView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBaseNaviBar()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let allContentView = AllFeedViewController.instantiate(withViewModel: self.viewModel)
        let followContentView = FollowFeedViewController.instantiate(withViewModel: self.viewModel)
        let popularContentView = PopularFeedViewController.instantiate(withViewModel: self.viewModel)
        
        return [allContentView, followContentView, popularContentView]
    }
}
