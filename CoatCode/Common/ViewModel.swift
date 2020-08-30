//
//  ViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa

class BaseViewModel: ViewModel, Stepper {
    let disposeBag = DisposeBag()
    
    let steps = PublishRelay<Step>()
    
    let loading = ActivityIndicator()
    let error = PublishSubject<ResponseError>()
    
    struct Input {
    }

    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

class ServicesBaseViewModel: ServicesViewModel, Stepper {
    let disposeBag = DisposeBag()
    
    let steps = PublishRelay<Step>()
    var services: CoatCodeService!
    
    let loading = ActivityIndicator()
    let error = PublishSubject<ResponseError>()
    
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
