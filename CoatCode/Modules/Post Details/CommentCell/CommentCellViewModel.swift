//
//  CommentCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/23.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CommentCellViewModel {
    
    let owner = BehaviorRelay<User?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let createTime = BehaviorRelay<Date?>(value: nil)
    
    let comment: Comment
    
    init(comment: Comment) {
        self.comment = comment
        
        self.owner.accept(comment.owner)
        self.content.accept(comment.content)
        self.createTime.accept(comment.createdAt)
    }
    
}
