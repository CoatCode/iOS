//
//  PostDetailViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxDataSources
import RxSwift
import RxCocoa
import RxKeyboard
import Kingfisher

class PostDetailViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = R.storyboard.postDetail()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint!

    var dataSource: RxCollectionViewSectionedReloadDataSource<PostDetailSection>!
    
    let deleteCommentSelected = PublishSubject<Comment>()
    let reportCommentSelected = PublishSubject<Comment>()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = ""

        collectionView.register(R.nib.postDetailCell)
        collectionView.register(R.nib.commentCell)

//        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
        
        setNavigationBar()
        dynamicKeyboard()
    }

    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = self.viewModel as? PostDetailViewModel else { fatalError("ViewModel Casting Falid!") }
        
        let user = viewModel.cellViewModel.value.post.owner
        guard let url = URL(string: user.image ?? "") else { return }
        let titleButton = self.setTitleButton(user.username, url)
        
        commentField.rx.text.orEmpty
            .bind(to: viewModel.commentText)
            .disposed(by: disposeBag)

        let input = PostDetailViewModel.Input(sendButtonTrigger: sendButton.rx.tap.asObservable(),
                                              profileTrigger: titleButton.rx.tap.asDriver(),
                                              deleteComment: deleteCommentSelected.asObservable(),
                                              reportComment: reportCommentSelected.asObservable())
        let output = viewModel.transform(input: input)

        self.dataSource = RxCollectionViewSectionedReloadDataSource<PostDetailSection>(configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .postDetailItem(let cellViewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.postDetailCell.identifier, for: indexPath) as? PostDetailCell)!
                cell.bind(to: cellViewModel, parentView: self)
                return cell
            case .commentItem(let viewModel):
                let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.commentCell.identifier, for: indexPath) as? CommentCell)!
                cell.bind(to: viewModel)
                return cell
            }
        })

        output.items
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.sendButtonEnabled
            .drive(self.sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.dismissKeyboard
            .drive(onNext: { [weak self] () in
                self?.commentField.resignFirstResponder()
                self?.commentField.text = nil
                viewModel.commentText.accept("")
            }).disposed(by: disposeBag)
        
        output.commentMoreSelected
            .drive(onNext: { [weak self] (comment) in
                self?.commentMore(comment)
            }).disposed(by: disposeBag)
    }
    
    func dynamicKeyboard() {
        RxKeyboard.instance.visibleHeight.drive(onNext: { [weak self] visibleHeight in
            guard let self = self else { return }

            if visibleHeight == 0 {
                self.commentBottomConstraint.constant = 0
            } else {
                let height = visibleHeight - self.view.safeAreaInsets.bottom
                self.commentBottomConstraint.constant = height
            }

            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }).disposed(by: disposeBag)
    }
    
    func setNavigationBar() {
        let moreButton =  UIBarButtonItem(image: R.image.more_Icon(), style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = moreButton
        
        moreButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.postMore()
            }).disposed(by: disposeBag)
    }
}

// MARK: - 댓글 삭제 / 신고
extension PostDetailViewController {
    func commentMore(_ comment: Comment) {
        if comment.owner?.id == DatabaseManager.shared.getCurrentUser().id {
            self.showAlert(title: "무엇이 하고 싶은가요?", message: nil, style: .actionSheet,
                           actions: [
                            AlertAction.action(title: "Delete", style: .destructive),
                            AlertAction.action(title: "Cancel", style: .cancel)
                           ]
            ).subscribe(onNext: { selectedIndex in
                switch selectedIndex {
                case 0:
                    self.deleteCommentSelected.onNext(comment)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        } else {
            self.showAlert(title: "무엇이 하고 싶은가요?", message: nil, style: .actionSheet,
                           actions: [
                            AlertAction.action(title: "Report this comment", style: .destructive),
                            AlertAction.action(title: "Cancel", style: .cancel)
                           ]
            ).subscribe(onNext: { selectedIndex in
                switch selectedIndex {
                case 0:
                    self.reportCommentSelected.onNext(comment)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        }
    }
}

// MARK: - 게시물 신고 / 삭제 - 수정
extension PostDetailViewController {
    func postMore() {
        guard let viewModel = self.viewModel as? PostDetailViewModel else { fatalError("ViewModel Casting Falid!") }

        let post = viewModel.cellViewModel.value.post

        if post.owner.id == DatabaseManager.shared.getCurrentUser().id {
            self.showAlert(title: "무엇이 하고 싶은가요?", message: nil, style: .actionSheet,
                           actions: [
                            AlertAction.action(title: "Edit"),
                            AlertAction.action(title: "Delete", style: .destructive),
                            AlertAction.action(title: "Cancel", style: .cancel)
                           ]
            ).subscribe(onNext: { selectedIndex in
                switch selectedIndex {
                case 0:
                    viewModel.editPost(post)
                case 1:
                    viewModel.deletePost(post.id)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        } else {
            self.showAlert(title: "무엇이 하고 싶은가요?", message: nil, style: .actionSheet,
                           actions: [
                            AlertAction.action(title: "Report this Post", style: .destructive),
                            AlertAction.action(title: "Cancel", style: .cancel)
                           ]
            ).subscribe(onNext: { selectedIndex in
                switch selectedIndex {
                case 0:
                    viewModel.reportPost(post.id)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        }
    }
}
