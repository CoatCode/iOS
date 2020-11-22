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

    var disposeBag = DisposeBag()

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }

    func bind(to viewModel: CommentCellViewModel) {

        viewModel.writerName.asDriver().drive(nameLabel.rx.text).disposed(by: disposeBag)

        viewModel.writerImageUrl.asDriver()
            .drive(onNext: { [weak self] url in
                self?.profileImageView.kf.setImage(with: url)
            }).disposed(by: disposeBag)

        viewModel.createTime.asDriver()
            .drive(onNext: { [weak self] date in
                self?.createTimeLabel.text = date?.timeAgoDisplay()
            }).disposed(by: disposeBag)

        viewModel.content.asDriver().drive(contentLabel.rx.text).disposed(by: disposeBag)

        moreButton.rx.tap.map { _ in viewModel.comment }
            .bind(to: viewModel.commentMore)
            .disposed(by: disposeBag)
    }
}
