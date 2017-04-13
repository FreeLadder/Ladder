//
//  LadderCell.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/4.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import UIKit

class LadderCell: UITableViewCell {
    private lazy var menuController: UIMenuController =  UIMenuController.shared
    @IBOutlet weak var ipLabel: MyLabel!
    @IBOutlet weak var portLabel: MyLabel!
    @IBOutlet weak var pwdLabel: MyLabel!
    @IBOutlet weak var encryptionLabel: MyLabel!
    private var ladder: Ladder?
    var menuItemHandler: ((String) -> Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(with ladder: Ladder) {
        self.ladder = ladder
        ipLabel.text = "ip：" + ladder.ip
        ipLabel.pasteString = ladder.ip
        portLabel.text = "端口：" + ladder.port
        portLabel.pasteString = ladder.port
        pwdLabel.text = "密码：" + ladder.password
        pwdLabel.pasteString = ladder.password
        encryptionLabel.text = "加密方式：" + ladder.encryption
        encryptionLabel.pasteString = ladder.encryption
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func cilckMenuItem() {
        if let url = ladder?.QRCodeURL {
            menuItemHandler?(url)
        }
    }
}
