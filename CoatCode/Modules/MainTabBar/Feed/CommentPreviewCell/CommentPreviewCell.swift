//
//  CommentPreviewCell.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/20.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class CommentPreviewCell: UICollectionViewCell {

    let disposeBag = DisposeBag()

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.profileImageView.roundCorners(.allCorners, radius: 0.5 * profileImageView.frame.width)
    }

    func bind(to viewModel: CommentPreviewCellViewModel) {

        viewModel.writerImageUrl.asDriver()
            .drive(onNext: { [weak self] urlString in
                guard let url = URL(string: urlString ?? "") else { return }
                self?.profileImageView.kf.setImage(with: url)
            }).disposed(by: disposeBag)

        viewModel.writerName.asDriver().drive(usernameLabel.rx.text).disposed(by: disposeBag)

        viewModel.content.asDriver().drive(contentLabel.rx.text).disposed(by: disposeBag)
    }
}
