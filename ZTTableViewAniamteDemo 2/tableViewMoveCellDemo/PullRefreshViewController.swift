//
//  PullRefreshViewController.swift
//  tableViewMoveCellDemo
//
//  Created by ZHAOTONG on 16/4/21.
//  Copyright © 2016年 ZHAOTONG. All rights reserved.
//

import UIKit

class PullRefreshViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let textLabel = UILabel()
    
    var datas = ["今天星期五", "上山打老虎", "老虎不在家", "专打他老母"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshView = ZTRefreshView(scrollView: tableView)
        refreshView.delegate = self
        tableView.addSubview(refreshView)
    }
}

extension PullRefreshViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pullCell", forIndexPath: indexPath)
        cell.textLabel?.text = datas[indexPath.row]
        
        let green = arc4random_uniform(256)
        let red = arc4random_uniform(256)
        let blue = arc4random_uniform(256)
        print(red)
        cell.backgroundColor = UIColor(colorLiteralRed: Float(red) / 256, green: Float(green) / 256, blue: Float(blue) / 256, alpha: 1)
        
        return cell
    }
}

extension PullRefreshViewController: RefreshDelegate {
    func doRefresh(refreshView: ZTRefreshView) {
        delay(2) {
            refreshView.endRefresh()
        }
    }
    
    func delay(secounds: Double, completion:() -> ()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * secounds))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
}
