//
//  AllFeedViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/04.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import XLPagerTabStrip
import RxDataSources
import KafkaRefresh

class AllFeedViewController: BaseViewController, StoryboardSceneBased, IndicatorInfoProvider {
    
    static let sceneStoryboard = UIStoryboard(name: "Feed", bundle: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }
        viewModel.filter.accept(FeedFilter.allContent)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "전체"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let input = FeedViewModel.Input(headerRefresh: headerRefreshTrigger,
                                        footerRefresh: footerRefreshTrigger,
                                        selection: tableView.rx.modelSelected(FeedCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        
        
        
        
    }
    
    func bindTableView() {
        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        })
        
        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })
        
        
        
        
    }
    


}
