//
//  UIViewController.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/12.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

struct AlertAction {
    var title: String
    var style: UIAlertAction.Style

    static func action(title: String, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}

extension UIViewController {

    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction])
     -> Observable<Int> {
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

    // profile image size 안맞음
    func setTitleButton(_ title: String, _ imageURL: URL) -> UIButton {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 48)

        let processor = DownsamplingImageProcessor(size: CGSize(width: 40, height: 40)) |> RoundCornerImageProcessor(cornerRadius: 20)
        button.kf.setImage(with: imageURL,
                                for: .normal,
                                options: [.processor(processor)])

        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)

        self.navigationItem.titleView = button
        return button
    }
}
