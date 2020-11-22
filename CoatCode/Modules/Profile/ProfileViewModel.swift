//
//  ProfileViewModel.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/05.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {

    let user: BehaviorRelay<User>

    init(user: User) {
        self.user =  BehaviorRelay(value: user)
    }
    
    struct Input {
        let followSelection: Observable<Void>
        let followerSelection: Driver<Void>
        let followingSelection: Driver<Void>
        let selection: Driver<PostPreviewCellViewModel>
    }
    
    struct Output {
        let postItems: Observable<[PostPreviewCellViewModel]>
        
        let profileUrl: Driver<URL?>
        let username: Driver<String>
        let description: Driver<String>
        let followerCount: Driver<String>
        let followingCount: Driver<String>
        let postCount: Driver<String>
        let productCount: Driver<String>
        
        let following: Driver<Bool>
        let hidesFollowButton: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let following = BehaviorRelay(value: false)
        
        let followed = input.followSelection.flatMapLatest { [weak self] () -> Observable<Void> in
            guard let self = self else { return Observable.just(()) }
            let userId = self.user.value.id
            let request = following.value == true ? self.services.unFollowUser(userId: userId) : self.services.followUser(userId: userId) 
            return request
                .trackActivity(self.loading)
        }
        
        input.followerSelection
            .drive(onNext: { [weak self] in
//                self?.steps.accept(<#T##event: Step##Step#>)
            }).disposed(by: disposeBag)
        
        input.followingSelection
            .drive(onNext: { [weak self] in
//                self?.steps.accept(<#T##event: Step##Step#>)
            }).disposed(by: disposeBag)
        
        input.selection
            .drive(onNext: { [weak self] cellViewModel in
                guard let self = self else { return }
                let post = cellViewModel.post
                let postCellViewModel = PostCellViewModel(post: post, services: self.services)
                self.steps.accept(CoatCodeStep.postDetailIsRequired(cellViewModel: postCellViewModel))
            }).disposed(by: disposeBag)
        
        let postItems = self.user.flatMapLatest { [weak self] (user) -> Observable<[PostPreviewCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            return self.services.userPosts(userId: user.id)
                .trackActivity(self.loading)
                .map { $0.map { PostPreviewCellViewModel(post: $0) } }
        }.share()
        
        let refreshFollowing = Observable.of(user.map { _ in }.asObservable(), followed).merge()
        refreshFollowing.flatMapLatest { [weak self] () -> Observable<RxSwift.Event<Void>> in
            guard let self = self else { return Observable.just(RxSwift.Event.next(())) }
            let userId = self.user.value.id
            return self.services.isFollowUser(userId: userId)
                .trackActivity(self.loading)
                .materialize()
        }.subscribe(onNext: { (event) in
            switch event {
            case .next:
                following.accept(true)
            case .error:
                following.accept(false)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
        
        let hidesFollowButton = user.map({ (user) -> Bool in
            let currentUser = DatabaseManager.shared.getCurrentUser()
            return user.id == currentUser.id
        }).asDriver(onErrorJustReturn: false)
        
        let profileUrl = user.map { URL(string: $0.image!) }.asDriver(onErrorJustReturn: URL(fileURLWithPath: ""))
        let username = user.map { $0.username }.asDriver(onErrorJustReturn: "")
        let description = user.map { $0.userDescription  }.asDriver(onErrorJustReturn: "")
        let folllowerCount = user.map { "\($0.followers)" }.asDriver(onErrorJustReturn: "0")
        let followingCount = user.map { "\($0.following)" }.asDriver(onErrorJustReturn: "0")
                                                                                        
        let postCount = postItems.map { "\($0.count)" }.asDriver(onErrorJustReturn: "0")
        let productCount = postItems.map { "\($0.count)" }.asDriver(onErrorJustReturn: "0") // 상품 받아올 경우에 추가해야함
        
        return Output(postItems: postItems,
                      profileUrl: profileUrl,
                      username: username,
                      description: description,
                      followerCount: folllowerCount,
                      followingCount: followingCount,
                      postCount: postCount,
                      productCount: productCount,
                      following: following.asDriver(),
                      hidesFollowButton: hidesFollowButton)
    }
}
