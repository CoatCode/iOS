//
//  Feedback.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/18.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

class FeedbackManager {
    
    /**
     충격이 발생했음을 나타내기위한 햅틱 피드백.
     
     - parameters:
        - style: 피드백 스타일
     */
    static func impactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /**
     선택 변경을 나타내기위한 햅틱 피드백.
     */
    static func selectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    /**
     성공, 실패 및 경고를 나타내기위한 햅틱 피드백.
     
     - parameters:
        - type: 피드백 타입
     */
    static func notificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
}
