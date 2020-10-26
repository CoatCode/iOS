//
//  CommentCell.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/22.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class CommentCell: UICollectionViewCell {

    let disposeBag = DisposeBag()

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        profileImageView.roundCorners(.allCorners, radius: 0.5 * profileImageView.frame.width)

        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
    }

    func bind(to viewModel: CommentCellViewModel, parentView: UIViewController) {

        guard let parentView = parentView as? PostDetailViewController else { return }

        viewModel.writerName.asDriver().drive(nameLabel.rx.text).disposed(by: disposeBag)

        viewModel.writerImageUrl.asDriver()
            .drive(onNext: { [weak self] urlString in
                guard let url = URL(string: urlString ?? "") else { return }
                self?.profileImageView.kf.setImage(with: url)
            }).disposed(by: disposeBag)

        viewModel.createTime.asDriver()
            .drive(onNext: { [weak self] date in
                self?.createTimeLabel.text = date?.timeAgoDisplay()
            }).disposed(by: disposeBag)

        viewModel.content.asDriver().drive(contentLabel.rx.text).disposed(by: disposeBag)

        self.moreButton.rx.tap
            .subscribe(onNext: {
                parentView.commentMore(viewModel.comment)
            }).disposed(by: disposeBag)
    }
}
