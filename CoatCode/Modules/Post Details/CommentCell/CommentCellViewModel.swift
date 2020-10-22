//
//  CommentCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/23.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

class CommentCellViewModel {
    
    let writerName = BehaviorRelay<String?>(value: nil)
    let writerImageUrl = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let createTime = BehaviorRelay<Date?>(value: nil)
    
    let comment: Comment
    
    init(with comment: Comment) {
        self.comment = comment
        
        self.writerName.accept(comment.owner.username)
        self.writerImageUrl.accept(comment.owner.image)
        self.content.accept(comment.content)
        self.createTime.accept(comment.createdAt)
    }
    
}
