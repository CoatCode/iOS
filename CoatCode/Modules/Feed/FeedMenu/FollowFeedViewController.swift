//
//  FollowFeedViewController.swift
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

class FollowFeedViewController: CollectionViewController, StoryboardSceneBased, IndicatorInfoProvider {

    static let sceneStoryboard = R.storyboard.feed()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<FeedSection>!

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "팔로우"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindCollectionView()

        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        collectionView.register(R.nib.feedCell)
        collectionView.register(R.nib.commentPreviewCell)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }
        viewModel.filter.accept(.followContent)
    }
    
    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = self.viewModel as? FeedViewModel else { fatalError("ViewModel Casting Falid!") }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = FeedViewModel.Input(headerRefresh: refresh,
                                        footerRefresh: footerRefreshTrigger,
                                        selection: collectionView.rx.modelSelected(FeedSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        self.dataSource = RxCollectionViewSectionedReloadDataSource<FeedSection>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .postItem(let cellViewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.feedCell.identifier, for: indexPath) as? FeedCell)!
                cell.bind(to: cellViewModel)
                return cell

            case .commentPreviewItem(let cellViewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.commentPreviewCell.identifier, for: indexPath) as? CommentPreviewCell)!
                cell.bind(to: cellViewModel)
                return cell
            }
        })

        output.items
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func bindCollectionView() {
        collectionView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            print("headerRefresh")
            self?.headerRefreshTrigger.onNext(())
        })

        collectionView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            print("footerRefresh")
            self?.footerRefreshTrigger.onNext(())
        })

        isHeaderLoading.bind(to: collectionView.headRefreshControl.rx.isAnimating).disposed(by: disposeBag)
        isFooterLoading.bind(to: collectionView.footRefreshControl.rx.isAnimating).disposed(by: disposeBag)
    }
}

extension FollowFeedViewController: UICollectionViewDelegateFlowLayout {
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
}
