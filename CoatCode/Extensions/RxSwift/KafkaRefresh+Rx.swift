//
//  KafkaRefresh+Rx.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/25.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import KafkaRefresh

extension Reactive where Base: KafkaRefreshControl {

    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { refreshControl, active in
            if active {
//                refreshControl.beginRefreshing()
            } else {
                refreshControl.endRefreshing()
            }
        }
    }
}

