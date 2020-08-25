//
//  loginService.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/31.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxSwift
import Moya

final class CoatCodeService: BaseService<CoatCodeAPI> {
    
    func signIn(email: String, password: String) -> Single<Response> {
        return request(.signIn(email, password))
    }
    
    func signUp(email: String, password: String, userName: String, profile: String) -> Single<Void> {
        return request(.signUp(email, password, userName, profile)).map { _ in }
    }
    
    func profile() -> Single<Response> {
        return request(.profile)
    }
    
}

extension CoatCodeService {
//    private func request(_ target: CoatCodeAPI) -> Single<Any> {
//        return request(target)
//            .mapJSON()
//            .observeOn(MainScheduler.instance)
//    }
//
//    private func requestWithoutMapping(_ target: CoatCodeAPI) -> Single<Moya.Response> {
//        return request(target)
//            .observeOn(MainScheduler.instance)
////            .asSingle()
//    }
//
//    private func requestObject<T: BaseMappable>(_ target: GithubAPI, type: T.Type) -> Single<T> {
//        return githubProvider.request(target)
//            .mapObject(T.self)
//            .observeOn(MainScheduler.instance)
//            .asSingle()
//    }
//
//    private func requestArray<T: BaseMappable>(_ target: GithubAPI, type: T.Type) -> Single<[T]> {
//        return githubProvider.request(target)
//            .mapArray(T.self)
//            .observeOn(MainScheduler.instance)
//            .asSingle()
//    }
}
