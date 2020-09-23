//
//  PostDetailViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class PostDetailViewModel: BaseViewModel {
    
    let post: Post
    
    init(with post: Post) {
        self.post = post
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
}

extension PostDetailViewModel {
    func transform(input: Input) -> Output {
        return Output()
    }
}
