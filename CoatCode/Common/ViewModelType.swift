//
//  ViewModelType.swift
//  CoatCode
//
//  Created by 강민석 on 2020/07/29.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

