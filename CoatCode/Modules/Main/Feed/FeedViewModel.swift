//
//  FeedViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/20.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

class FeedViewModel: Stepper, ServicesViewModel {
        
    var services: CoatCodeService!
    var steps = PublishRelay<Step>()

    struct Input {
        
    }
    
    struct Output{
        
    }
    
    
}

// MARK: - Transform
extension FeedViewModel {
    func transform(input: Input) -> Output {
        Output()
    }
}
