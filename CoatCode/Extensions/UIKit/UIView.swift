//
//  UIView.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/14.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            if(corners.contains(.allCorners)){
                cornerMask.insert(.layerMinXMinYCorner)
                cornerMask.insert(.layerMaxXMinYCorner)
                cornerMask.insert(.layerMinXMaxYCorner)
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask
            
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
