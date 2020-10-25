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
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.roundCorners(.allCorners, radius: self.profileImageView.frame.width / 2)
    }
    
    func bind(to viewModel: PostCellViewModel) {
        
        viewModel.profileImageUrl.asDriver()
            .drive(onNext: { [weak self] urlString in
                guard let url = URL(string: urlString ?? "") else { return }
                self?.profileImageView.kf.setImage(with: url)
            }).disposed(by: disposeBag)
        
        viewModel.username.asDriver().drive(profileNameLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.imageUrls.asDriver()
            .drive(onNext: { [weak self] imageUrl in
                self?.thumbnailImageView.kf.indicatorType = .activity
                self?.thumbnailImageView.kf.setImage(with: imageUrl?.first)
            }).disposed(by: disposeBag)
        
        viewModel.title.asDriver().drive(titleLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.isLiked.asDriver()
            .drive(onNext: { [weak self] isLiked in
                if isLiked ?? false {
                    self?.likeImageView.image = UIImage(named: "Like_Icon") // Like
                } else {
                    self?.likeImageView.image = UIImage(named: "UnLike_Icon") // UnLike
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
        
        viewModel.createdTime.asDriver()
            .drive(onNext: { [weak self] date in
                self?.createdTimeLabel.text = date?.timeAgoDisplay()
            }).disposed(by: disposeBag)
        
        self.likeImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                if viewModel.isLiked.value ?? false {
                    viewModel.unLike()
                } else {
                    viewModel.like()
                }
            }).disposed(by: disposeBag)
    }
}
