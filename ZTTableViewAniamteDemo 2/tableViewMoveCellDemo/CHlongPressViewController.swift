//
//  ViewController.swift
//  tableViewMoveCellDemo
//
//  Created by ZHAOTONG on 16/4/19.
//  Copyright © 2016年 ZHAOTONG. All rights reserved.
//

import UIKit

class CHlongPressViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var snapShot: UIView? = nil
    var sourceIndexPath: NSIndexPath? = nil
    
    let data: NSMutableArray = ["以热爱祖国为荣", "以危害祖国为耻", "以服务人民为荣", "以背离人民为耻", "以崇尚科学为荣", "以愚昧无知为耻", "以辛勤劳动为荣", "以好逸恶劳为耻"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(CHlongPressViewController.longPressGestureRecognized))
        tableView.addGestureRecognizer(longPress)
    }
    
    func longPressGestureRecognized(sender: AnyObject) {
        let longPress = sender as! UILongPressGestureRecognizer
        let state = longPress.state
        
        let location = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(location)
  
        switch state {
            
        case UIGestureRecognizerState.Began:
            guard let index = indexPath else { return }
            sourceIndexPath = indexPath
            let cell = tableView.cellForRowAtIndexPath(index) ?? UITableViewCell()
            
            snapShot = cell.snapshotViewAfterScreenUpdates(true)
            guard let snapshot = snapShot else { return }
            snapshot.layer.masksToBounds = false
            snapshot.layer.cornerRadius = 0.0
            snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
            snapshot.layer.shadowRadius = 5.0
            snapshot.layer.shadowOpacity = 0.4
            
            var center = cell.center
            snapshot.center = center
            snapshot.alpha = 0
            tableView.addSubview(snapshot)
        
            UIView.animateWithDuration(0.25, animations: { 
                //offset for gesture location
                center.y = location.y
                snapshot.center = center
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05)
                snapshot.alpha = 0.5
                
                cell.alpha = 0
                cell.backgroundColor = UIColor.purpleColor()
                }, completion: { _ in
//                    cell.hidden = true
            })
            break
        case UIGestureRecognizerState.Changed:
            guard let snapshot = snapShot else { return }
            
            var center = snapshot.center
            center.y = location.y
            snapshot.center = center

            guard let sourceIndex = sourceIndexPath else { return }
            guard let index = indexPath else { return }
            if !index.isEqual(sourceIndexPath) {
                data.exchangeObjectAtIndex(index.row, withObjectAtIndex: sourceIndex.row)
                tableView.moveRowAtIndexPath(sourceIndex, toIndexPath: index)
                sourceIndexPath = index
            }
            
        default:
            guard let sourceIndex = sourceIndexPath else { return }
            guard let snapshot = snapShot else { return }
            let cell = tableView.cellForRowAtIndexPath(sourceIndex) ?? UITableViewCell()
            UIView.animateWithDuration(0.25, animations: { 
                snapshot.center = cell.center
                snapshot.transform = CGAffineTransformIdentity
                snapshot.alpha = 0
                cell.alpha = 1
                
                }, completion: { _ in
                    cell.hidden = false
                    snapshot.removeFromSuperview()
            })
        }
    }
}

extension CHlongPressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell") ?? UITableViewCell()
        cell.textLabel?.text = data[indexPath.row] as? String
        return cell
    }
    
}

