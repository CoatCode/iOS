//
//  UploadImageCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/11/01.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class UploadImageCellViewModel {

    let image = BehaviorRelay<UIImage?>(value: nil)
    let isHiddenDelete = BehaviorRelay(value: false)
    let parentViewModel: UploadPostViewModel

    init(image: UIImage, isHiddenDelete: Bool = false, viewModel: UploadPostViewModel) {
        self.parentViewModel = viewModel
        self.image.accept(image)
        self.isHiddenDelete.accept(isHiddenDelete)
    }

    func deleteImage() {
        guard let image = self.image.value else { return }
        parentViewModel.deleteImage(image: image)
    }
}
