//
//  ImageBarButton.swift
//  CoatCode
//
//  Created by 강민석 on 2020/09/05.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

class ImageBarButton: UIView {
    var imageView: UIImageView!
    var button: UIButton!

    convenience init(withUrl imageURL: URL? = nil, withImage image: UIImage? = nil, frame: CGRect = CGRect(x: 0, y: 0, width: 30, height: 30)) {
        self.init(frame: frame)

        imageView = UIImageView(frame: frame)
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = frame.height / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        button = UIButton(frame: frame)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        addSubview(button)

        if let url = imageURL {
            self.imageView.kf.setImage(with: url)
        } else if let image = image {
            self.imageView.image = image
        }
    }

    func load() -> UIBarButtonItem {
        return UIBarButtonItem(customView: self)
    }
}
