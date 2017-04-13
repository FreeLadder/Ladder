//
//  Util.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/3.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import UIKit

class Creater {
    static let shared = Creater()
    
    final func makeLadder(completionHandler: @escaping ([Ladder], Error?) -> Void) {
        DispatchQueue.global().async {
            let n = NetworkUtil.shared
            n.start()
            n.completionHandler = { (data, e) in
                let s = String(data: data, encoding: .utf8)!
                let list = s.getLadderTagList()
                var ladders = [Ladder]()
                for i in list {
                    let ipTag = i.getItem(type: RegularExpression.ipTag)
                    let portTag = i.getItem(type: RegularExpression.portTag)
                    let passwordTag = i.getItem(type: RegularExpression.passwordTag)
                    let encryptionTag = i.getItem(type: RegularExpression.encryptionTag)
                    let QRCodeTag = i.getItem(type: RegularExpression.QRCodeTag)
                    
                    let ip = ipTag.getItem(type: RegularExpression.ip)
                    let port = portTag.getItem(type: RegularExpression.port)
                    let password = passwordTag.getItem(type: RegularExpression.password)
                    let encryption = encryptionTag.substring(with: encryptionTag.index(encryptionTag.startIndex, offsetBy: 7)..<encryptionTag.index(encryptionTag.endIndex, offsetBy: -5))
                    let QRCode = Config.urlString + QRCodeTag.getItem(type: RegularExpression.QRCode)
                    
                    let ladder = Ladder(ip: ip, port: port, password: password, encryption: encryption, QRCodeURL: QRCode)
                    ladders.append(ladder)
                }
                completionHandler(ladders, e)
            }
        }
    }
}


class NetworkUtil: NSObject {
    static let shared = NetworkUtil()
    fileprivate var data: Data = Data()
    var completionHandler: ((Data, Error?) -> Void)?
    
    final func start() {
        let url = URL(string: Config.urlString)!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 6)
        request.allowsCellularAccess = true
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
        session.finishTasksAndInvalidate()
    }
}


extension NetworkUtil: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        completionHandler?(self.data, error)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
