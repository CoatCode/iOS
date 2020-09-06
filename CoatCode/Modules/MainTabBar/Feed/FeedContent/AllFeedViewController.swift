//
//  AllFeedViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/04.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import XLPagerTabStrip

class AllFeedViewController: BaseViewController, StoryboardSceneBased, IndicatorInfoProvider {
    
    static let sceneStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    func a() {
//        print("aaaaa")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.viewModel.steps.accept(CoatCodeStep.postDetailIsRequired(postId: 123))
//        }
//    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "전체"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let input = FeedViewModel.Input()
        let output = viewModel.transform(input: input)
        
        
        
    }
    


}
