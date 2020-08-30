//
//  ViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/30.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxFlow
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import SwiftMessages

class ViewController: UIViewController, ViewModelBased, NVActivityIndicatorViewable {
    
    let disposeBag = DisposeBag()
    
    var viewModel: ServicesBaseViewModel!
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<ResponseError>()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
 
    func bindViewModel() {
        viewModel.loading.asObservable().bind(to: self.isLoading).disposed(by: disposeBag)
        viewModel.error.bind(to: self.error).disposed(by: disposeBag)
        
        isLoading.subscribe(onNext: { isLoading in
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
}
