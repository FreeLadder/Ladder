//
//  ViewController.swift
//  FreeSS
//
//  Created by YogaXiong on 2017/4/3.
//  Copyright © 2017年 YogaXiong. All rights reserved.
//

import UIKit

private let cellId = NSStringFromClass(LadderCell.self)

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var ladders = [Ladder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configRefreshControl()
        configTableView()
        loadData()
    }
    
    
    func loadData() {
        refreshControl.beginRefreshing()
        Creater.shared.makeLadder { [weak self] (ladders, error) in
            DispatchQueue.main.async {
                if error != nil || ladders.isEmpty {
                    self?.noticeError((error?.localizedDescription) ?? "获取数据失败")
                } else {
                    self?.ladders = ladders
                    self?.tableView.reloadData()
                    self?.refreshControl.attributedTitle = NSAttributedString(string: Date.current(format: "HH:mm"))
                }
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func configTableView() {
        tableView.register(UINib(nibName: "LadderCell", bundle: .main), forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    private func configRefreshControl() {
        refreshControl.addTarget(self, action: #selector(ViewController.loadData), for: .valueChanged)
    }
    
    
    func saveQRCodeImage(url: String) {
        ImageUtil.shared.downloadImage(url: URL(string: url)!, progressBlock: nil) { [weak self] (data, image, error, finished) in
            guard let i = image else { return }
            ImageUtil.shared.save(image: i) { (success, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self?.noticeError("保存失败")
                    } else {
                        self?.noticeOnStatusBar("保存成功")
                    }
                }
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ladders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? LadderCell
        let ladder = ladders[indexPath.row]
        cell?.config(with: ladder)
        cell?.menuItemHandler = saveQRCodeImage
//        print(indexPath.row, ladder.toURL())
        return cell!
    }

    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let i = UIMenuItem(title: "保存二维码", action: #selector(LadderCell.cilckMenuItem))
        UIMenuController.shared.menuItems = [i]
        UIMenuController.shared.update()
        return true
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action == #selector(LadderCell.cilckMenuItem)
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
    }
    
}

