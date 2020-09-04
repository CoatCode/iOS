//
//  CustomTabBarViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/04.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

//import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip
import NVActivityIndicatorView
import SwiftMessages

class CustomTabBarViewController: ButtonBarPagerTabStripViewController, ViewModelBased, NVActivityIndicatorViewable {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var viewModel: BaseViewModel!
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<ResponseError>()
    
    // MARK: - View life cycle
    override public func viewDidLoad() {
        setCustomTabBar()
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - BindViewModel
    public func bindViewModel() {
        viewModel.loading.asObservable().bind(to: self.isLoading).disposed(by: disposeBag)
        viewModel.error.bind(to: self.error).disposed(by: disposeBag)
        
        isLoading.subscribe(onNext: { [weak self] isLoading in
            self?.view.endEditing(true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }).disposed(by: disposeBag)
        
        isLoading.asDriver().drive(onNext: { [weak self] isLoading in
            isLoading ? self?.startAnimating(type: .circleStrokeSpin) : self?.stopAnimating()
        }).disposed(by: disposeBag)
        
        error.subscribe(onNext: { error in
            let errorView = MessageView.viewFromNib(layout: .cardView)
            errorView.configureTheme(.error)
            errorView.configureContent(title: "\(error.status!) 에러", body: error.message)
            errorView.button?.isHidden = true
            SwiftMessages.show(view: errorView)
        }).disposed(by: disposeBag)
    }
    
    public func setCustomTabBar() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 1.5
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 30
        settings.style.buttonBarRightContentInset = 30
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
        }
    }
    
}
