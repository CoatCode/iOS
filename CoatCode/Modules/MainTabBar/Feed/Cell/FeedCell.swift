//
//  FeedCollectionViewCell.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/13.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class FeedCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView! // 버튼으로 수정 예정
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(to viewModel: FeedCellViewModel) {
        
        viewModel.profileImageUrl.asDriver()
            .drive(onNext: { [weak self] urlString in
                guard let url = URL(string: urlString ?? "") else { return }
                self?.profileImageView.kf.setImage(with: url)
            }).disposed(by: disposeBag)
        
        viewModel.profileName.asDriver().drive(profileNameLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.contentImageUrl.asDriver()
            .drive(onNext: { [weak self] imageUrl in
                self?.thumbnailImageView.kf.setImage(with: imageUrl)
            }).disposed(by: disposeBag)
        
        viewModel.content.asDriver().drive(titleLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.isLiked.asDriver()
            .drive(onNext: { [weak self] isLiked in
                if isLiked ?? false {
                    self?.likeButton.setImage(UIImage(named: "Like_Icon"), for: .normal) // Like
                } else {
                    self?.likeButton.setImage(UIImage(named: "UnLike_Icon"), for: .normal) // UnLike
                }
            }).disposed(by: disposeBag)
        
        viewModel.likeCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.likeCountLabel.text = "\(count ?? 0)"
            }).disposed(by: disposeBag)
        
        viewModel.viewCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.viewCountLabel.text = "\(count ?? 0)"
            }).disposed(by: disposeBag)
        
        viewModel.commentCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.commentCountLabel.text = "\(count ?? 0)"
            }).disposed(by: disposeBag)
        
//        moreButton.rx.tap
//            .bind(to: viewMdoel.moreButtonClicked)
//            .disposed(by: disposeBag)
    }
    
}
