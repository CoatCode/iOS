//
//  UIViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/12.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift

struct AlertAction {
    var title: String
    var style: UIAlertAction.Style
    
    static func action(title: String, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}

extension UIViewController {
    
    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction])
     -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}
