//
//  ImageUtil.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/5.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import UIKit
import Photos

typealias DownloaderProgressBlock = (_ recivedSize: Int64, _ totalSize: Int64) -> ()
typealias DownloaderCompletionHandler = (_ data: Data?, _ image: UIImage?, _ error: Error?, _ finished: Bool) -> ()


class ImageUtil: NSObject {
    static let shared = ImageUtil()
    fileprivate var data: Data = Data()
    fileprivate var expectedContentSize: Int64 = 0
    fileprivate var progressBlock: DownloaderProgressBlock?
    fileprivate var completionHandler: DownloaderCompletionHandler?
    
    private func authorized() -> Bool {
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .notDetermined {
            return true
        } else {
            return false
        }
    }
    
    private func askForAuthorization() {
        guard let rc =  UIApplication.shared.keyWindow?.rootViewController else { return }
        let alertC = UIAlertController(title: "请授权", message: "允许Ladder存照片!", preferredStyle: UIAlertControllerStyle.alert)
        let setting = UIAlertAction(title: "去设置", style: .default) { (action) in
            let url = URL(string: "prefs:root=Photo&path=com.YogaXiong.FreeSS")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertC.addAction(cancel)
        alertC.addAction(setting)
        rc.present(alertC, animated: true, completion: nil)
    }
    
    func downloadImage(url: URL, progressBlock: DownloaderProgressBlock?, completionHandler: DownloaderCompletionHandler?) {
        self.progressBlock = progressBlock
        self.completionHandler = completionHandler
        data = Data()
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func save(image: UIImage, completionHandler:((Bool, Error?) -> Void)?) {
        if !authorized() {
            askForAuthorization()
            return
        }
        
        PHPhotoLibrary.shared().performChanges({ 
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if let e = error {
                completionHandler?(false, e)
            } else {
                completionHandler?(true, nil)
            }
        
        }
    }
}

extension ImageUtil: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        expectedContentSize = response.expectedContentLength
        completionHandler(.allow)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data)
        progressBlock?(Int64(self.data.count), expectedContentSize)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            completionHandler?(data, nil , error, false)
        }else {
            completionHandler?(data, UIImage(data: data) , nil, true)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
