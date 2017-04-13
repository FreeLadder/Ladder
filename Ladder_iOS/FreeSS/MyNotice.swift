//
//  MyNotice.swift
//  MyNotice
//
//  Created by YogaXiong on 16/9/27.
//  Copyright © 2016年 YogaXiong. All rights reserved.
//

import UIKit

extension UIResponder {
    
    func noticeOnStatusBar(_ text: String, autoClear: Bool = true, autoClearTime: Int = 1) {
        MyNotice.showNoticeOnStatusBar(text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    func noticeText(_ text: String) {
        MyNotice.showText(text)
    }
    
    func noticeSuccess(_ text: String, autoClear: Bool = true, autoClearTime: Int = 1) {
        MyNotice.showNoticeWithText(.success, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    func noticeInfo(_ text: String, autoClear: Bool = true, autoClearTime: Int = 1) {
        MyNotice.showNoticeWithText(.info, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    func noticeError(_ text: String, autoClear: Bool = true, autoClearTime: Int = 1) {
        MyNotice.showNoticeWithText(.error, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    func noticeWait(_ images: [UIImage], duration: Int) {
        MyNotice.wait(images, duration: duration)
    }
    
    func clearNotice() {
        MyNotice.clear()
    }
}

enum NoticeType {
    case success, error, info
}

class MyNotice: NSObject {
    static var windows = [UIWindow]()
    static let rv = UIApplication.shared.windows.first as UIView!
    static var timer: DispatchSource!
    static var timerTimes = 0
    static var degree: Double {
        return [0, 0, 270 ,90][UIApplication.shared.statusBarOrientation.hashValue] as Double
    }
    
    class func clear() {
        self.cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer {
            timer.cancel()
            timer = nil
            timerTimes = 0
        }
        windows.removeAll(keepingCapacity: false)
    }
    
    class func showNoticeOnStatusBar(_ text: String, autoClear: Bool, autoClearTime: Int) {
        let window = UIWindow()
        let mainView = UIView()
        let label = UILabel()
        
        window.backgroundColor = UIColor.clear
        mainView.backgroundColor = UIColor(red: 0x6a/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
        
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.sizeToFit()
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        mainView.frame = statusBarFrame
        label.frame = statusBarFrame
        
        label.center = mainView.center
        window.center = rv!.center
        window.windowLevel = UIWindowLevelStatusBar
        window.isHidden = false
        
        window.addSubview(mainView)
        mainView.addSubview(label)
        windows.append(window)
        
        if autoClear {
            perform(#selector(self.hideNotice(_:)), with: window, afterDelay: TimeInterval(autoClearTime))
        }
    }
    
    class func showText(_ text: String) {
        let window = UIWindow()
        let mainView = UIView()
        let label = UILabel()
        
        window.backgroundColor = UIColor.clear
        
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.sizeToFit()
        
        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50, height: label.frame.height + 50)
        mainView.frame = superFrame
        window.frame = superFrame
        
        label.center = mainView.center
        window.center = rv!.center
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        mainView.addSubview(label)
        window.addSubview(mainView)
        
        windows.append(window)
    }
    
    class func showNoticeWithText(_ type: NoticeType, text: String, autoClear: Bool, autoClearTime: Int) {
        let window = UIWindow()
        let mainView = UIView()
        let label = UILabel()
        let imageView = UIImageView()
        
        window.backgroundColor = UIColor.clear
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.sizeToFit()
        
        var image: UIImage?
        switch type {
        case .success:
            image = MyNoticeSDK.imageOfCheckmark
        case .error:
            image = MyNoticeSDK.imageOfCross
        case .info:
            image = MyNoticeSDK.imageOfInfo
        }
        imageView.image = image
        
        let superFrame = CGRect(x: 0, y: 0, width: 90, height: 90)
        label.frame = CGRect(x: 0, y: 60, width: 90, height: 16)
        imageView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.frame = superFrame
        window.frame = superFrame
        
        window.center = rv!.center
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        
        window.addSubview(mainView)
        mainView.addSubview(imageView)
        mainView.addSubview(label)
        windows.append(window)

        if autoClear {
            perform(#selector(self.hideNotice(_:)), with: window, afterDelay: TimeInterval(autoClearTime))
        }
    }
    
    class func wait(_ images: [UIImage], duration: Int = 0) {
        
    }
    
    class func hideNotice(_ sender: AnyObject?) {
        if let window = sender as? UIWindow {
            if let index = windows.index(where: { (item) -> Bool in
                return item == window
            }) {
                windows.remove(at: index)
            }
        }
    }
}

fileprivate class MyNoticeSDK {
    struct Cache {
        static var imageOfCheckMark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    class func draw(_ type: NoticeType) {
        let checkmarkShapePath = UIBezierPath()
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        checkmarkShapePath.close()
        switch type {
        case .success:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .error:
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    
    class var imageOfCheckmark: UIImage {
        if Cache.imageOfCheckMark != nil {
            return Cache.imageOfCheckMark!
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0.0)
        MyNoticeSDK.draw(.success)
        Cache.imageOfCheckMark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckMark!
    }
    
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        MyNoticeSDK.draw(.error)
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        MyNoticeSDK.draw(.info)
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
