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
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? PostDetailViewModel else { fatalError("ViewModel Casting Falid!") }
        
        commentField.rx.text.orEmpty
            .bind(to: viewModel.commentText)
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        let input = PostDetailViewModel.Input(sendButtonTrigger: sendButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<PostDetailSection>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .postDetailItem(let viewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "PostDetailCell", for: indexPath) as? PostDetailCell)!
                cell.bind(to: viewModel)
                return cell
            case .commentItem(let viewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as? CommentCell)!
                cell.bind(to: viewModel)
                return cell
            }
        })
        
        output.items
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
    
    

}
