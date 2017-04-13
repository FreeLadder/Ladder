//
//  Ladder.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/3.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import Foundation

struct Ladder: CustomStringConvertible {
    let ip: String
    let port: String
    let password: String
    let encryption: String
    let QRCodeURL: String
    
    init(ip: String, port: String, password: String, encryption: String, QRCodeURL: String) {
        self.ip = ip
        self.port = port
        self.password = password
        self.encryption = encryption
        self.QRCodeURL = QRCodeURL
    }
    
    var description: String {
        return "ip: \(ip)" + "\n" + "port: \(port)" + "\n" + "password: \(password)" + "\n" + "encryption: \(encryption)" + "\n" + "QRCodeURL: \(QRCodeURL)" + "\n"
    }
    
    func toURL() -> URL {
        //        服务器:端口:协议:加密方式:混淆方式:base64（密码）？obfsparam= Base64(混淆参数)&remarks=Base64(备注)
        let parts = "\(encryption):\(password)@\(ip):\(port)".base64(urlSafe: false)
        return URL(string: "ss://\(parts)")!
    }

}
