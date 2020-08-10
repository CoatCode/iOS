//
//  MainTabBarController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/09.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

class MainTabBarContoller: UITabBarController {
    
    let home = FeedCoordinator()
    let category = StoreCoordinator()
    let store = WritingCoordinator()
    let bookmark = FavoritesCoordinator()
    let profile = SettingCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    func setupViewControllers() {
        viewControllers = [home.navigationController, category.navigationController, store.navigationController, bookmark.navigationController, profile.navigationController]
        
        
        
        
        
            // 탭별 아이콘 및 이름을 지정하는 코드를 여기 혹은 원하는 곳에 작업해주세요
    }
    
}
