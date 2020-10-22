//
//  CommentPreviewCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/20.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class CommentPreviewCellViewModel {
    
    let writerName = BehaviorRelay<String?>(value: nil)
    let writerImageUrl = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    
    let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
        
        self.writerName.accept(comment.owner.username)
        self.writerImageUrl.accept(comment.owner.image)
        self.content.accept(comment.content)
    }
    
}
