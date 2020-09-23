//
//  PostDetailCellViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/23.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PostDetailCellViewModel {
    
    let contentImageUrls = BehaviorRelay<[String]?>(value: nil)
    let content = BehaviorRelay<String?>(value: nil)
    let likeCount = BehaviorRelay<Int?>(value: nil)
    let commentCount = BehaviorRelay<Int?>(value: nil)
    let viewCount = BehaviorRelay<Int?>(value: nil)
    let isLiked = BehaviorRelay<Bool?>(value: nil)
    let tag = BehaviorRelay<String?>(value: nil)
    
    
    
}
