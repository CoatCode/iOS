//
//  WritingViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/27.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

class WritingViewModel: Stepper, ServicesViewModel {
    
    var services: CoatCodeService!
    var steps = PublishRelay<Step>()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    
}

// MARK: - Transform
extension WritingViewModel {
    func transform(input: Input) -> Output {
        Output()
    }
}
