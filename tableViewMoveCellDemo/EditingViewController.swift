//
//  EditingViewController.swift
//  tableViewMoveCellDemo
//
//  Created by ZHAOTONG on 16/4/19.
//  Copyright © 2016年 ZHAOTONG. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var isTableEditing: Bool = false
    
    let data: NSMutableArray = ["以热爱祖国为荣", "以危害祖国为耻", "以服务人民为荣", "以背离人民为耻", "以崇尚科学为荣", "以愚昧无知为耻", "以辛勤劳动为荣", "以好逸恶劳为耻"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.editing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editTable(){
        tableView.setEditing(!isTableEditing, animated: true)
//        tableView
//        tableView.editing = !isTableEditing
        isTableEditing = !isTableEditing
    }
    
    @IBAction func editingAction(sender: AnyObject) {
        editTable()
        
//        tableView.beginUpdates()
//        self.data.removeObjectAtIndex(3)
//        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .Right)
//        CATransaction.setCompletionBlock {
//            CATransaction.setDisableActions(true)
//            self.tableView.reloadData()
//            CATransaction.commit()
//        }
//        tableView.endUpdates()
    }


}

extension EditingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("editingCell") ?? UITableViewCell()
        cell.textLabel?.text = data[indexPath.row] as? String
        
        let swipGesture = UIPanGestureRecognizer()
        swipGesture.addTarget(self, action: #selector(EditingViewController.editTable))
        return cell
    }
    
//Mark: Edit Mode
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let topAction = UITableViewRowAction(style: .Normal, title: "TOP") { (action: UITableViewRowAction, indexPath: NSIndexPath) in
            self.data.exchangeObjectAtIndex(0, withObjectAtIndex: indexPath.row)
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: NSIndexPath(forItem: 0, inSection: 0 ))
            tableView.editing = false
            self.isTableEditing = false
        }
        
        let collectAction = UITableViewRowAction(style: .Default, title: "collect") { (action: UITableViewRowAction, indexPath: NSIndexPath) in
            
        }
        
        let deleteAction = UITableViewRowAction(style: .Destructive, title: "DELETE") { (action: UITableViewRowAction, indexPath: NSIndexPath) in
            
            tableView.beginUpdates()
            self.data.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .Right)
            CATransaction.setCompletionBlock {
                CATransaction.setDisableActions(false)
                self.tableView.reloadData()
                CATransaction.commit()
            }
            tableView.endUpdates()
            
            tableView.editing = false
            self.isTableEditing = false
        }
    
//        collectAction.backgroundColor = UIColor.init(patternImage: UIImage(named:"2") ?? UIImage())
        return [topAction,deleteAction,collectAction]
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let fromRow = sourceIndexPath.row
        let toRow = destinationIndexPath.row
        let object = data.objectAtIndex(fromRow)
        data.removeObjectAtIndex(fromRow)
        data.insertObject(object, atIndex: toRow)
    }
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
}