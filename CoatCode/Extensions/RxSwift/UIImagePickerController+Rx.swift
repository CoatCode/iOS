//
//  UIImagePickerController+Rx.swift
//  CoatCode
//
//  Created by 강민석 on 2020/08/23.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIImagePickerController {

    var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
        return RxImagePickerDelegateProxy.proxy(for: base)
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (images) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, images[1])
            })
    }
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
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
