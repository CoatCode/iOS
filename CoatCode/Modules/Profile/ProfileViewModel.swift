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
    
    let userId: Int
    
    init(userId: Int) {
        self.userId = userId
    }
    
    
}
