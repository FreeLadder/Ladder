//
//  StringUtil.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/13.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import Foundation

extension String {
    func getLadderTagList() -> [String] {
        let expression = Regex.makeRegularExpression(pattern: RegularExpression.listTag.rawValue)
        let result = expression.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
        
        var stringArray = [String]()
        for item in result {
            let s = (self as NSString).substring(with: item.range)
            stringArray.append(s)
        }
        return stringArray
    }
    
    
    func getItem(type: RegularExpression) -> String {
        let expression = Regex.makeRegularExpression(pattern: type.rawValue)
        
        guard let result = expression.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count)) else {
            return ""
        }
        let s = (self as NSString).substring(with: result.range)
        return s
    }
    
    func base64(urlSafe:Bool=true) -> String{
        var encodeStr = self.data(using: String.Encoding.utf8)!.base64EncodedString(options: Data.Base64EncodingOptions())
        if(urlSafe){
            encodeStr = encodeStr.replacingOccurrences(of: "+", with: "-")
            encodeStr = encodeStr.replacingOccurrences(of: "/", with: "_")
            encodeStr = encodeStr.replacingOccurrences(of: "=", with: "")
        }
        return encodeStr
    }
}


struct Regex {
    static func makeRegularExpression(pattern: String) -> NSRegularExpression {
        var expression: NSRegularExpression!
        do {
            expression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        } catch let e {
            print(e)
        }
        return expression
    }
}

enum RegularExpression: String {
    case listTag = "<div class=\"hover-bg\">(.*?)</div>"
    case ipTag = "IP Address:<span id=\"\\b(.*?)\">(.*?)</span>"
    case portTag = "<h4>Port：(\\d+?)</h4>"
    case passwordTag = "Password:<span id=\"\\b(.*?)\">(.*?)</span>"
    case encryptionTag = "Method:(.*?)</h4>"
    case QRCodeTag = "a href=\"(.*?)\""
    
    case ip = "\\w+\\W\\w+\\W\\w+"
    case port = "\\d{2,9}"
    case password = "\\d+"
    case QRCode = "\\w{3}/\\w{2}/\\w{3,5}\\Wpng"
}
