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

class FeedViewController: CustomTabBarViewController, StoryboardSceneBased {

    // MARK: - Properties
    static let sceneStoryboard = UIStoryboard(name: "Feed" , bundle: nil)
    
    @IBOutlet weak var feedTableView: UITableView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let allContentView = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "AllFeedViewController")
        let followContentView = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "FollowFeedViewController")
        let popularContentView = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "PopularFeedViewController")
        
        return [allContentView, followContentView, popularContentView]
    }
    
    // MARK: - BindViewModel
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }
        
        
        
        
    }
    
}
