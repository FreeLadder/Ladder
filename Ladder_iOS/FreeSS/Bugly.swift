//
//  Bugly.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/6.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import Foundation

class Bug {
    static let AppID = "ab06a1625a"
    static let AppKey = "51bdb210-a604-4286-b0e4-e6b480511093"
    
    class func config() -> BuglyConfig {
        let config = BuglyConfig()
        config.reportLogLevel = .warn
        config.debugMode = true
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            config.version = version
        }
        return config
        
    }
}
