//
//  LikesViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/11/19.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxDataSources
import RxSwift
import RxCocoa
import Kingfisher

class LikesViewController: BaseViewController, StoryboardSceneBased {
    
    static let sceneStoryboard = R.storyboard.likes()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Likes"

        tableView.register(R.nib.likesCell)

//        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
    }
    
    override func bindViewModel() {
        guard let viewModel = self.viewModel as? LikesViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let input = LikesViewModel.Input(selectProfile: tableView.rx.modelSelected(User.self).asDriver())
        let output = viewModel.transform(input: input)
        
        output.items.bind(to: tableView.rx.items(cellIdentifier: "LikesCell", cellType: LikesCell.self)) { (index: Int, element: User, cell: LikesCell) in
            cell.profileImage.kf.setImage(with: URL(string: element.image!))
            cell.username.text = element.username
        }.disposed(by: disposeBag)
    }
}
