//
//  DateUtil.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/13.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import Foundation

extension Date {
    static func current(format: String) -> String {
        let date = Date(timeIntervalSinceNow: 0)
        let tz = TimeZone.current
        let df = DateFormatter()
        df.timeZone = tz
        df.dateFormat = format
        return df.string(from: date)
    }
}
