//
//  PostDetailViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxDataSources
import RxSwift
import RxCocoa

class PostDetailViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = UIStoryboard(name: "PostDetail", bundle: nil)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? PostDetailViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let input = PostDetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<PostDetailSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .contentItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as? PostDetailCell)!
                cell.bind(to: viewModel)
                return cell
            case .commentItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as? CommentCell)!
                cell.bind(to: viewModel)
                return cell
            }
            
        })
        
        output.items
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
    
    

}
