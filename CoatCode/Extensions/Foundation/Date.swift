//
//  Date.swift
//  CoatCode
//
//  Created by 강민석 on 2020/10/06.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import Foundation

extension Date {

//    func localTime() -> Date {
//        let timezone = TimeZone.current
//        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
//        return Date(timeInterval: seconds, since: self)
//    }

    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

}
