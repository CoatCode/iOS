//
//  CreateProfileViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/10.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow
import RxGesture

class CreateProfileViewController: UIViewController, StoryboardSceneBased, ViewModelBased {
    
    // MARK: - Properties
    static let sceneStoryboard = UIStoryboard(name: "Intro" , bundle: nil)
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: CreateProfileViewModel!
    
    let isLoading = BehaviorRelay(value: false)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindImagePicker()
    }
}

// MARK: - BindViewModel
extension CreateProfileViewController {
    func bindViewModel() {
        
        nameField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        
        let imageObs: Observable<UIImage?> = self.profileImageView.rx.observe(UIImage.self, "image")
        let defaultImage = UIImage(named: "user")!
        let imageWithDefaultObs: Observable<UIImage> = imageObs.map {
            return $0 ?? defaultImage
        }
        
        imageWithDefaultObs
            .bind(to: viewModel.profileImage)
            .disposed(by: disposeBag)
        
        let input = CreateProfileViewModel.Input(signUpTrigger: signUpButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
    }
}

// MARK: - BindImagePicker
extension CreateProfileViewController {
    func bindImagePicker() {
        
        let imagePicker = imagePickerScene(
            on: self,
            modalPresentationStyle: .formSheet,
            modalTransitionStyle: .none
        )

        profileImageView.rx.tapGesture()
            .flatMapLatest { _ in Observable.create(imagePicker) }
            .compactMap { $0[.originalImage] as? UIImage }
            .bind { image in
                self.profileImageView.clipsToBounds = true
                self.profileImageView.image = image
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - SetUI
extension CreateProfileViewController {
    //    func setUI() {
    //        self.profileImageView.
    //    }
}

func imagePickerScene(on presenter: UIViewController, modalPresentationStyle: UIModalPresentationStyle? = nil, modalTransitionStyle: UIModalTransitionStyle? = nil) -> (_ observer: AnyObserver<[UIImagePickerController.InfoKey: AnyObject]>) -> Disposable {
    return { [weak presenter] observer in
        let controller = UIImagePickerController()
        if let presentationStyle = modalPresentationStyle {
            controller.modalPresentationStyle = presentationStyle
        }
        if let transitionStyle = modalTransitionStyle {
            controller.modalTransitionStyle = transitionStyle
        }
        presenter?.present(controller, animated: true)
        return controller.rx.didFinishPickingMediaWithInfo
            .do(onNext: { _ in
                presenter?.dismiss(animated: true)
            })
            .subscribe(observer)
    }
}

final class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, UINavigationControllerDelegate & UIImagePickerControllerDelegate>, DelegateProxyType, UINavigationControllerDelegate & UIImagePickerControllerDelegate {

    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }

    static func registerKnownImplementations() {
        self.register { RxImagePickerDelegateProxy(parentObject: $0, delegateProxy: RxImagePickerDelegateProxy.self) }
     }
}

extension Reactive where Base: UIImagePickerController {

    var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
        return RxImagePickerDelegateProxy.proxy(for: base)
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
