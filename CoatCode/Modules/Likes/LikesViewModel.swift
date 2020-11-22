//
//  LikesViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/11/19.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class LikesViewModel: BaseViewModel {
    
    let postId: BehaviorRelay<Int>

    init(with postId: Int) {
        self.postId = BehaviorRelay(value: postId)
    }

    struct Input {
        let selectProfile: Driver<User>
    }

    struct Output {
        let items: Observable<[User]>
    }
 
    func transform(input: Input) -> Output {
        
        input.selectProfile
            .drive(onNext: { [weak self] (user) in
                self?.steps.accept(CoatCodeStep.profileIsRequired(user: user))
            }).disposed(by: disposeBag)
        
        let elements = postId.flatMapLatest { [weak self] (postId) -> Observable<[User]> in
            guard let self = self else { return Observable.just([]) }
            return self.services.likedPeoples(postId: postId)
                .trackActivity(self.loading)
        }
        
        return Output(items: elements)
    }
}
