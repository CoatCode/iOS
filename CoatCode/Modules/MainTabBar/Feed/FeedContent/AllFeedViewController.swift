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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<FeedSection>!
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "전체"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.register(UINib(nibName: "FeedCell", bundle: nil), forCellWithReuseIdentifier: "FeedCell")
        collectionView.register(UINib(nibName: "CommentPreviewCell", bundle: nil), forCellWithReuseIdentifier: "CommentPreviewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }
        viewModel.filter.accept(FeedFilter.allContent)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let input = FeedViewModel.Input(headerRefresh: Observable.of(Observable.just(()), headerRefreshTrigger).merge(),
                                        footerRefresh: footerRefreshTrigger,
                                        selection: collectionView.rx.modelSelected(FeedSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)
        
        self.dataSource = RxCollectionViewSectionedReloadDataSource<FeedSection>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .postItem(let cellViewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell)!
                cell.bind(to: cellViewModel)
                return cell
                
            case .commentPreviewItem(let cellViewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CommentPreviewCell", for: indexPath) as? CommentPreviewCell)!
                cell.bind(to: cellViewModel)
                return cell
            }
        })
        
        output.items
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)  
    }
    
    func bindTableView() {
        collectionView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            print("headerRefresh")
            self?.headerRefreshTrigger.onNext(())
        })
        
        collectionView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            print("footerRefresh")
            self?.footerRefreshTrigger.onNext(())
        })
    }
}

extension AllFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.bounds.width
        
        switch dataSource[indexPath] {
        case .postItem:
            return CGSize(width: cellWidth, height: cellWidth * 0.984) // 1 : 0.984 -> 게시물 비율
        case .commentPreviewItem:
            return CGSize(width: cellWidth, height: 40)
        }
    }
    
    // 지정된 섹션의 여백을 반환하는 메서드.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    // 지정된 섹션의 행 사이 간격 최소 간격을 반환하는 메서드. scrollDirection이 horizontal이면 수직이 행이 되고 vertical이면 수평이 행이 된다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 지정된 섹션의 셀 사이의 최소간격을 반환하는 메서드.
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    // 지정된 섹션의 푸터뷰의 크기를 반환하는 메서드. 크기를 지정하지 않으면 화면에 보이지 않습니다.
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 10)
//    }
    
    
}
