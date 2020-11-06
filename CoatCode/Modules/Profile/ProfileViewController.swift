//
//  ProfileViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/05.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class ProfileViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = R.storyboard.profile()

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followerCountView: UIStackView!
    @IBOutlet weak var followingCountView: UIStackView!

    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImageView.roundCorners(.allCorners, radius: 0.5 * profileImageView.frame.width)
        self.collectionView.register(R.nib.postPreviewCell)
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = self.viewModel as? ProfileViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let followButton = UIBarButtonItem(image: R.image.bt_Follow(), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = followButton
        
        let followerSelection = followerCountView.rx.tapGesture().map { _ in }.asDriver(onErrorJustReturn: ())
        let followingSelection = followingCountView.rx.tapGesture().map { _ in }.asDriver(onErrorJustReturn: ())
        
        let input = ProfileViewModel.Input(followSelection: followButton.rx.tap.asObservable(),
                                           followerSelection: followerSelection,
                                           followingSelection: followingSelection,
                                           selection: collectionView.rx.modelSelected(PostPreviewCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)
        
        output.postItems.asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: R.reuseIdentifier.postPreviewCell.identifier, cellType: PostPreviewCell.self)) { collectionView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: disposeBag)
        
        output.profileUrl.drive(onNext: { [weak self] (imageUrl) in
            self?.profileImageView.kf.setImage(with: imageUrl)
        }).disposed(by: disposeBag)
        
        output.username.drive(nameLabel.rx.text).disposed(by: disposeBag)
        output.description.drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        output.followerCount.drive(followerCountLabel.rx.text).disposed(by: disposeBag)
        output.followingCount.drive(followingCountLabel.rx.text).disposed(by: disposeBag)
        output.postCount.drive(postCountLabel.rx.text).disposed(by: disposeBag)
        output.productCount.drive(productCountLabel.rx.text).disposed(by: disposeBag)
        
        output.following.drive(onNext: { (isFollow) in
            followButton.image = isFollow == true ? R.image.bt_UnFollow() : R.image.bt_Follow()
        }).disposed(by: disposeBag)
        
        output.hidesFollowButton.drive(onNext: { [weak self] (isHide) in
            if isHide {
                self?.navigationItem.rightBarButtonItem = nil
            }
        }).disposed(by: disposeBag)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) / 3
        
        return CGSize(width: width - 3, height: width - 3)
    }
    
    // 지정된 섹션의 셀 사이의 최소간격을 반환하는 메서드.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
