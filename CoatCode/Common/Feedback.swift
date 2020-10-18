//
//  Feedback.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/18.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

class Feedback {
    
    static func feedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
}
