//
//  PostPreviewCell.swift
//  CoatCode
//
//  Created by 강민석 on 2020/11/01.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostPreviewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bind(to viewModel: PostPreviewCellViewModel) {
        viewModel.imageUrl.asDriver()
            .drive(onNext: { [weak self] (imageUrl) in
                self?.imageView.kf.setImage(with: imageUrl)
            }).disposed(by: disposeBag)
    }
}
