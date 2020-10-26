//
//  CollectionViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/25.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KafkaRefresh

class CollectionViewController: BaseViewController {

    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: disposeBag)
    }

}
