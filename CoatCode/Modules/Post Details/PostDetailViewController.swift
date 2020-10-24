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
import RxKeyboard

class PostDetailViewController: BaseViewController, StoryboardSceneBased {
    
    static let sceneStoryboard = UIStoryboard(name: "PostDetail", bundle: nil)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint!
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<PostDetailSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "PostDetailCell", bundle: nil), forCellWithReuseIdentifier: "PostDetailCell")
        collectionView.register(UINib(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
        
        //        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        //            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        //        }
        
        RxKeyboard.instance.visibleHeight.drive(onNext: { [weak self] visibleHeight in
            guard let self = self else { return }
            
            if visibleHeight == 0 {
                self.commentBottomConstraint.constant = 0
            } else {
                let height = visibleHeight - self.view.safeAreaInsets.bottom
                self.commentBottomConstraint.constant = height
            }
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }).disposed(by: disposeBag)
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = self.viewModel as? PostDetailViewModel else { fatalError("ViewModel Casting Falid!") }
        
        commentField.rx.text.orEmpty
            .bind(to: viewModel.commentText)
            .disposed(by: disposeBag)
        
        let input = PostDetailViewModel.Input(sendButtonTrigger: sendButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        self.dataSource = RxCollectionViewSectionedReloadDataSource<PostDetailSection>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .postDetailItem(let cellViewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "PostDetailCell", for: indexPath) as? PostDetailCell)!
                cell.bind(to: cellViewModel, parentView: self)
                return cell
            case .commentItem(let viewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as? CommentCell)!
                cell.bind(to: viewModel, parentView: self)
                return cell
            }
        })
        
        output.items
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.sendButtonEnabled
            .drive(self.sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.sendComplete
            .drive(onNext: { [weak self] (isComplete) in
                if isComplete {
                    self?.view.endEditing(true)
                    self?.commentField.text = nil
                }
            }).disposed(by: disposeBag)
    }
    
    func commentMore(_ comment: Comment) {
        //        guard let viewModel = self.viewModel as? PostDetailViewModel else { fatalError("ViewModel Casting Falid!") }
        //
        //        self.showAlert(title: "무엇이 하고 싶은가요?", message: "message", style: .actionSheet,
        //                       actions: [
        //                        AlertAction.action(title: "Delete", style: .destructive),
        //                        AlertAction.action(title: "Edit"),
        //                        AlertAction.action(title: "Cancel", style: .cancel)
        //                       ]
        //        ).subscribe(onNext: { selectedIndex in
        //            switch selectedIndex {
        //            case 0:
        //
        //            case 1:
        //
        //            default:
        //                break
        //            }
        //
        //        }).disposed(by: disposeBag)
    }
}
