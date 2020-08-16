//
//  IntroViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift

class IntroViewModel {
    
    struct Input {
        let signInTrigger: Observable<Void>
        let signUpTrigger: Observable<Void>
        let socialLoginTrigger: Observable<Void>
    }
    
    struct Output {
        let success: Bool
    }
    
    let disposedBag = DisposeBag()
    
    let signIn = PublishSubject<Void>()
    let signUp = PublishSubject<Void>()
    let socialLogin = PublishSubject<Void>()
    
    func transform(input: Input) -> Output {
        
        input.signInTrigger
            .subscribe(onNext: { [weak self] in
                self?.signIn.onNext(())
            }).disposed(by: disposedBag)
        
        input.signUpTrigger
            .subscribe(onNext: { [weak self] in
                self?.signUp.onNext(())
            }).disposed(by: disposedBag)
        
        input.socialLoginTrigger
            .subscribe(onNext: { [weak self] in
                self?.socialLogin.onNext(())
            }).disposed(by: disposedBag)
        
        return Output(success: true)
    }
    
}
