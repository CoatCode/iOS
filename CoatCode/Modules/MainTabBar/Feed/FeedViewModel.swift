//
//  FeedViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/20.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class FeedViewModel: BaseViewModel {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output{
        
    }
    
    
}

// MARK: - Transform
extension FeedViewModel {
    func transform(input: Input) -> Output {
        
        
        
        
        
        Output()
    }
    
    // 필터에 따른 게시물 요청
    func request() -> Observable<[Post]> {
        
    }
    
}
