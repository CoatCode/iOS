//
//  UploadImageCell.swift
//  CoatCode
//
//  Created by 강민석 on 2020/11/01.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UploadImageCell: UICollectionViewCell {

    let disposeBag = DisposeBag()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.imageView.roundCorners(.allCorners, radius: 10)
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    func bind(to viewModel: UploadImageCellViewModel) {
        viewModel.image.asDriver().drive(imageView.rx.image).disposed(by: disposeBag)
        viewModel.isHiddenDelete.asDriver().drive(deleteButton.rx.isHidden).disposed(by: disposeBag)
        deleteButton.rx.tap
            .subscribe(onNext: {
                viewModel.deleteImage()
            }).disposed(by: disposeBag)
    }
}
