//
//  PostPreviewCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/11/01.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class PostPreviewCellViewModel {
    
    let post: Post
    let imageUrl = BehaviorRelay<URL?>(value: nil)
    
    init(post: Post) {
        self.post = post
        
        self.imageUrl.accept(post.imageURLs.first)
    }
}
