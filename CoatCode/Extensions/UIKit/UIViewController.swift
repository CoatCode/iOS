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

    func setTitle(_ title: String, _ imageURL: URL) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill

        let processor = DownsamplingImageProcessor(size: CGSize(width: 30, height: 30)) |> RoundCornerImageProcessor(cornerRadius: 15)
        imageView.kf.setImage(with: imageURL, options: [.processor(processor)])

        let titleView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        titleView.axis = .horizontal
        titleView.alignment = .center
        titleView.distribution = .fillProportionally
        titleView.spacing = 5.0

        navigationItem.titleView = titleView
    }
}
