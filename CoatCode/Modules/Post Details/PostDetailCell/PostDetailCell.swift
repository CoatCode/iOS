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
import Tags
import RxTags

class PostDetailCell: UICollectionViewCell {

    let disposeBag = DisposeBag()

    @IBOutlet weak var slideshow: ImageSlideshow!

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tagView: TagsView!

    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!

    @IBOutlet weak var createdTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.slideshow.contentScaleMode = .scaleAspectFill
        self.setTagView()
    }

    func setTagView() {
        self.tagView.tagLayerColor = .clear
        self.tagView.tagFont = .systemFont(ofSize: 12)
        self.tagView.tagTitleColor = Configs.BaseColor.tagColor
        self.tagView.paddingHorizontal = 0
        self.tagView.paddingVertical = 0
        self.tagView.marginHorizontal = 0
        self.tagView.marginVertical = 0
    }

    func bind(to viewModel: PostCellViewModel, parentView: UIViewController) {

        guard let parentView = parentView as? PostDetailViewController else { return }

        // 좋아요 여부 체킹
        viewModel.checkLiking()

        // 게시물 이미지 표시
        viewModel.imageUrls.asDriver()
            .drive(onNext: { [weak self] images in
                var imageInputs = [KingfisherSource]()
                for image in images! {
                    imageInputs.append(KingfisherSource(url: image))
                }
                self?.slideshow.setImageInputs(imageInputs)
            }).disposed(by: disposeBag)

        // 게시물 제목 표시
        viewModel.title.asDriver().drive(titleLabel.rx.text).disposed(by: disposeBag)

        // 게시물 내용 표시
        viewModel.content.asDriver().drive(contentLabel.rx.text).disposed(by: disposeBag)

        // 좋아요수 표시
        viewModel.likeCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.likeCountLabel.text = "\(count ?? 0) Likes"
            }).disposed(by: disposeBag)

        // 조회수 표시
        viewModel.viewCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.viewCountLabel.text = "\(count ?? 0) Views"
            }).disposed(by: disposeBag)

        // 댓글수 표시
        viewModel.commentCount.asDriver()
            .drive(onNext: { [weak self] count in
                self?.commentCountLabel.text = "\(count ?? 0) Comments"
            }).disposed(by: disposeBag)

        // 좋아요 여부 표시
        viewModel.isLiked.asDriver()
            .drive(onNext: { [weak self] isLiked in
                if isLiked ?? false {
                    self?.likeImageView.image = UIImage(named: "Like_Icon")
                } else {
                    self?.likeImageView.image = UIImage(named: "UnLike_Icon")
                }
            }).disposed(by: disposeBag)

        viewModel.tag.asDriver()
            .drive(onNext: { [weak self] tags in
                guard let tags = tags else { return }
                self?.tagView.append(contentsOf: tags)
            }).disposed(by: disposeBag)

        // timeAgo 표시
        viewModel.createdTime.asDriver()
            .drive(onNext: { [weak self] date in
                self?.createdTimeLabel.text = date?.timeAgoDisplay()
            }).disposed(by: disposeBag)

        // tag result로 이동
        tagView.rx.touchAction()
            .subscribe(onNext: { tag in
//                parentView.viewModel.steps.accept(<#T##event: Step##Step#>)
            }).disposed(by: disposeBag)

        // likes로 이동
        self.likeCountLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
//                parentView.viewModel.steps.accept(<#T##event: Step##Step#>)
            }).disposed(by: disposeBag)

        // 좋아요 기능
        self.likeImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                if viewModel.isLiked.value ?? false {
                    viewModel.unLike()
                } else {
                    viewModel.like()
                }
            }).disposed(by: disposeBag)

        // slideshow 확대
        self.slideshow.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.slideshow.presentFullScreenController(from: parentView)
            }).disposed(by: disposeBag)
    }
}
