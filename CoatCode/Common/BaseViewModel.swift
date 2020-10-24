//
//  BaseViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

class BaseViewModel: ServicesViewModel, Stepper {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    let steps = PublishRelay<Step>()
    var services: CoatCodeService!
    
    let loading = ActivityIndicator()
    let error = PublishSubject<ErrorResponse>()
    
    var page = 1
    
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
    
    // MARK: - Dummy
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
