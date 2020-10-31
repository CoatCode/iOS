//
//  UploadPostViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class UploadPostViewModel: BaseViewModel {

    let imageList = BehaviorRelay(value: [R.image.add_Icon()!])
    let title = BehaviorRelay(value: "")
    let content = BehaviorRelay(value: "")
    let tags = BehaviorRelay(value: [""])

    let uploadComplete = PublishSubject<Bool>()

    struct Input {
        let uploadTrigger: Observable<Void>
    }

    struct Output {
        let items: BehaviorRelay<[UploadImageCellViewModel]>
        let uploadComplete: PublishSubject<Bool>
    }
}

// MARK: - Transform
extension UploadPostViewModel {
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[UploadImageCellViewModel]>(value: [])

        imageList
            .subscribe(onNext: { images in
                var cellViewModels = [UploadImageCellViewModel]()
                images.enumerated().forEach { (index, element) in
                    if index == 0 {
                        cellViewModels.append(UploadImageCellViewModel(image: element, isHiddenDelete: true, viewModel: self))
                    } else {
                        cellViewModels.append(UploadImageCellViewModel(image: element, viewModel: self))
                    }
                }
                elements.accept(cellViewModels)
            }).disposed(by: disposeBag)

        input.uploadTrigger.flatMapLatest { [weak self] () -> Observable<Void> in
            guard let self = self else { return Observable.just(()) }

            let images = self.imageList.value
            let title = self.title.value
            let content = self.content.value
            let tag = self.tags.value
            return self.services.writePost(images: images, title: title, content: content, tag: tag)
                .trackActivity(self.loading)
        }.subscribe(onNext: { [weak self] in
            self?.uploadComplete.onNext(true)
        }).disposed(by: disposeBag)

        return Output(items: elements, uploadComplete: uploadComplete)
    }
}

extension UploadPostViewModel {
    func deleteImage(image: UIImage) {
        var imageList = self.imageList.value
        if let index = imageList.firstIndex(of: image) {
            imageList.remove(at: index)
        }
        self.imageList.accept(imageList)
    }
}
