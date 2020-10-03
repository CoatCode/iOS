//
//  PostDetailCell.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/22.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ImageSlideshow

class PostDetailCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(to viewModel: PostDetailCellViewModel) {
        
        viewModel.contentImageUrls.asDriver()
            .drive(onNext: { [weak self] images in
                let a = []
                for image in images {
                    a.append(KingfisherSource(image))
                }
                self?.slideshow.setImageInputs(a)
            }).disposed(by: disposeBag)
        
        viewModel.title.asDriver().drive(titleLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.content.asDriver().drive(contentLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.commentCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.likeCountLabel.text = "\(count ?? 0) Likes"
            }).disposed(by: disposeBag)
        
        viewModel.viewCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.viewCountLabel.text = "\(count ?? 0) Views"
            }).disposed(by: disposeBag)
        
        viewModel.commentCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.commentCountLabel.text = "\(count ?? 0) Comments"
            }).disposed(by: disposeBag)
        
        viewModel.isLiked.asDriver()
            .drive(onNext: { [weak self] isLiked in
                if isLiked ?? false {
                    self?.likeButton.setImage(UIImage(named: "Like_Icon"), for: .normal) // Like
                } else {
                    self?.likeButton.setImage(UIImage(named: "UnLike_Icon"), for: .normal) // UnLike
                }
            }).disposed(by: disposeBag)
        
        viewModel.tag.asDriver().drive(tagLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.createdTime.asDriver()
            .drive(onNext: { [weak self] date in
                self?.createTimeLabel.text = date?.timeAgoDisplay()
            }).disposed(by: disposeBag)
    }
}
