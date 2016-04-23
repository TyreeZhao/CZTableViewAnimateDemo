//
//  headerViewController.swift
//  tableViewMoveCellDemo
//
//  Created by Tong Zhao on 16/4/23.
//  Copyright © 2016年 ZHAOTONG. All rights reserved.
//

import UIKit

class headerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    var datas = ["今天星期五", "上山打老虎", "老虎不在家", "专打他老母","今天星期五", "上山打老虎", "老虎不在家", "专打他老母","今天星期五", "上山打老虎", "老虎不在家", "专打他老母","今天星期五", "上山打老虎", "老虎不在家", "专打他老母"]
    
    let headerHeight: CGFloat = 200
    let menuHeight: CGFloat = 44
    var titleLabel = UILabel()

    var defaultOffsetY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        defaultOffsetY = -(headerHeight + menuHeight)
        guard let defaultOffsetY = defaultOffsetY else { return }
        tableView.contentInset = UIEdgeInsetsMake( -defaultOffsetY , 0, 0, 0)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let image = UIImage.imageWithColor(UIColor.clearColor())
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)

        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width - 100, height: 30.0))
        label.font = UIFont.systemFontOfSize(17)
        label.text = "发起宴请"
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.sizeToFit()
        navigationItem.titleView = label
        titleLabel = label
        titleLabel.alpha = 0
        titleLabel.hidden = true
    }

}

extension headerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.lightGrayColor()
        cell.textLabel?.text = datas[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let defaultOffsetY = defaultOffsetY else { return }
        let offsetY = scrollView.contentOffset.y
        let delta = offsetY - defaultOffsetY
        print("offsetY=\(offsetY)")
        print("defaultOffsetY = \(defaultOffsetY)")
        print("delta = \(delta)")
        
        var headerViewHeight: CGFloat = headerHeight - delta
        
        if headerViewHeight <= 64 {
            headerViewHeight = 64
        }
        
        headerViewHeightConstraint.constant = headerViewHeight
        
        var alpha = delta / ( headerHeight )
        
        if alpha > 0 {
            titleLabel.hidden = false
            if alpha >= 1{
                alpha = 0.99
            }
        } else {
            titleLabel.hidden = true
        }
        print("alpha = \(alpha)")
        titleLabel.alpha = alpha
        
        let image = UIImage.imageWithColor(UIColor.init(white: 1, alpha: alpha))
        navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        
    }
}

extension UIImage {
    
    public class func imageWithColor(color : UIColor ) -> UIImage {
        // 描述矩形
        let rect = CGRectMake(0, 0, 1, 1)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 获取位图上下文c
        let context = UIGraphicsGetCurrentContext()
        // 使用color演示填充上下文
        CGContextSetFillColorWithColor(context, color.CGColor)
        // 渲染上下文
        CGContextFillRect(context, rect)
        // 从上下文中获取图片
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        // 结束上下文
        UIGraphicsEndImageContext()
        return theImage
    }
}



