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
    
    func signUp(email: String, password: String, userName: String, profile: String) -> Single<Response> {
        return request(.signUp(email, password, userName, profile))
    }
    
    func profile() -> Single<Response> {
        return request(.profile)
    }
    
}

extension CoatCodeService {
//    private func request(_ target: GithubAPI) -> Single<Any> {
//        return githubProvider.request(target)
//            .mapJSON()
//            .observeOn(MainScheduler.instance)
//            .asSingle()
//    }
//
//    private func requestWithoutMapping(_ target: GithubAPI) -> Single<Moya.Response> {
//        return githubProvider.request(target)
//            .observeOn(MainScheduler.instance)
//            .asSingle()
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
