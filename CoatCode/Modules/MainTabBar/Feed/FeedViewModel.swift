//
//  FeedViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/20.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

enum FeedFilter {
    case allContent
    case followContent
    case popularContent
}

class FeedViewModel: BaseViewModel {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output{
        
    }
    
    let filter = BehaviorRelay(value: FeedFilter.allContent)
    
    
}

// MARK: - Transform
extension FeedViewModel {
    func transform(input: Input) -> Output {
        
        let elements = BehaviorRelay<[Post]>(value: [])
        
        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[Post]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
            
        }).subscribe(onNext: { items in
            elements.accept(items)
        }).disposed(by: disposeBag)
        
        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[Post]> in
            guard let self = self else { return Observable.of([]) }
            self.page += 1
            return request()
            
        }).subscribe(onNext: { items in
            elements.accept(items)
        }).disposed(by: disposeBag)
        
        
        
        return Output()
    }
    
    // 필터에 따른 게시물 요청
    func request() -> Observable<[Post]> {
        
        switch self.filter.value {
        case .allContent:
            return self.services.allFeedPosts(page: <#T##Int#>)
        case .followContent:
            return
        case .popularContent:
            return
        }
        
        
    }
    
}
