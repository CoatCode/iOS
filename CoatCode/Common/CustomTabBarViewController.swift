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
    let error = PublishSubject<ErrorResponse>()

    // MARK: - View life cycle
    override public func viewDidLoad() {
        configureCustomTabBar()
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
            errorView.configureContent(title: "\(error.status!) 에러", body: error.message.first!)
            errorView.button?.isHidden = true
            SwiftMessages.show(view: errorView)
        }).disposed(by: disposeBag)
    }

    // MARK: - Configure CustomTabBar
    public func configureCustomTabBar() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = Configs.BaseColor.navBarTintColor
        settings.style.buttonBarItemBackgroundColor = Configs.BaseColor.navBarTintColor

        settings.style.selectedBarBackgroundColor = Configs.BaseColor.signatureColor

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
            newCell?.label.textColor = Configs.BaseColor.signatureColor
        }
    }

    // MARK: - Configure Navigation Bar
    func configureBaseNaviBar() {
        self.navigationController?.navigationBar.barTintColor = Configs.BaseColor.navBarTintColor
        self.navigationController?.navigationBar.shadowImage = UIImage()

        setIconBar() // Left
        setProfileShortcutBar() // Right
        setSearchBar() // Title
    }

    func setIconBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cocoIcon"), style: .plain, target: nil, action: nil)
    }

    func setProfileShortcutBar() {
        let profileBarButton = ImageBarButton(withImage: UIImage(named: "Default_Profile"))
        profileBarButton.button.addTarget(self, action: #selector(requestProfileView), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = profileBarButton.load()
    }

    @objc func requestProfileView() {
        self.viewModel.steps.accept(CoatCodeStep.profileIsRequired(uesrId: 1234)) // 사용자 userId
    }

    func setSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.steps.accept(CoatCodeStep.searchIsRequired)
                searchController.searchBar.endEditing(true)
            }).disposed(by: disposeBag)
    }
}
