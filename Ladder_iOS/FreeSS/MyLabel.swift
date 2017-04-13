//
//  MyLabel.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/4.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import UIKit

class MyLabel: UILabel {
    var pasteString: String?
    private lazy var menuController: UIMenuController =  UIMenuController.shared
    private lazy var item = UIMenuItem(title: "复制", action: #selector(MyLabel.copyHandler))

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func config() {
        isUserInteractionEnabled = true
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MyLabel.longPressGestureHandler(gesture:)))
        addGestureRecognizer(longPressGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(MyLabel.receive(noti:)), name: Notification.Name.UIMenuControllerDidHideMenu, object: nil)
    }
    
    func longPressGestureHandler(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            if menuController.isMenuVisible { return }
            becomeFirstResponder()
            backgroundColor = UIColor.orange
            
            menuController.setTargetRect(CGRect(x: gesture.location(in: self).x, y: gesture.location(in: self).y, width: 0, height: 0), in: self)
            menuController.menuItems = [item]
            menuController.setMenuVisible(true, animated: true)
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(MyLabel.copyHandler)
    }
    
    func copyHandler() {
        copyText()
        reset()
    }
    
    func receive(noti: Notification) {
        guard let mc = noti.object as? UIMenuController, mc.menuItems?.contains(item) == true else { return }
        reset()
    }
    
    private func copyText() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = pasteString
        noticeOnStatusBar("已贴")
    }
    
    private func reset() {
        backgroundColor = UIColor.white
    }

}
