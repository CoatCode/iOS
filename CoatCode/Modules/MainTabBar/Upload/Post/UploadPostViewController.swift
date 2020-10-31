//
//  UploadPostViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Tagging

class UploadPostViewController: BaseViewController, StoryboardSceneBased {

    static let sceneStoryboard = R.storyboard.upload()

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var taggingView: Tagging!

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageFrame: UIView!
    @IBOutlet weak var contentFrame: UIView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setCollectionView()
        bindUploadImage()
        setTaggingView()
    }

    override func bindViewModel() {
        super.bindViewModel()

        guard let viewModel = self.viewModel as? UploadPostViewModel else { fatalError("ViewModel Casting Falid!") }

        self.dismissButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        self.titleField.rx.text.orEmpty
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)

        self.contentTextView.rx.text.orEmpty
            .bind(to: viewModel.content)
            .disposed(by: disposeBag)

        let input = UploadPostViewModel.Input(uploadTrigger: self.uploadButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: R.reuseIdentifier.uploadImageCell.identifier, cellType: UploadImageCell.self)) { collectionView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: disposeBag)

        output.uploadComplete
            .subscribe(onNext: { [weak self] isComplete in
                if isComplete {
                    self?.dismiss(animated: true)
                }
            }).disposed(by: disposeBag)
    }

    func bindUploadImage() {
        guard let viewModel = self.viewModel as? UploadPostViewModel else { fatalError("ViewModel Casting Falid!") }

        let imagePicker = imagePickerScene(
            on: self,
            modalPresentationStyle: .formSheet,
            modalTransitionStyle: .none
        )

        self.collectionView.rx.tapGesture()
            .when(.recognized)
            .flatMapLatest { _ in Observable.create(imagePicker) }
            .compactMap { $0[.originalImage] as? UIImage }
            .bind { image in
                viewModel.imageList.accept(viewModel.imageList.value + [image])
            }.disposed(by: disposeBag)
    }

    func setUI() {
        self.imageFrame.roundCorners(.allCorners, radius: 15)
        self.contentFrame.roundCorners(.allCorners, radius: 15)

        self.navigationBar.barTintColor = Configs.BaseColor.navBarTintColor
        self.navigationBar.shadowImage = UIImage()
    }

    func setCollectionView() {
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        self.collectionView.register(R.nib.uploadImageCell)

        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.showsHorizontalScrollIndicator = false
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }

    func setTaggingView() {
        self.taggingView.dataSource = self
        self.taggingView.symbol = "#"
    }
}

extension UploadPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.frame.height
        return CGSize(width: cellHeight, height: cellHeight)
    }

    // 지정된 섹션의 여백을 반환하는 메서드.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension UploadPostViewController: TaggingDataSource {
    func tagging(_ tagging: Tagging, didChangedTagableList tagableList: [String]) {
        guard let viewModel = self.viewModel as? UploadPostViewModel else { fatalError("ViewModel Casting Falid!") }
        viewModel.tags.accept(tagableList)
    }
}
