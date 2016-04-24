//
//  ZTRefreshView.swift
//  tableViewMoveCellDemo
//
//  Created by ZHAOTONG on 16/4/21.
//  Copyright © 2016年 ZHAOTONG. All rights reserved.
//

import UIKit

protocol RefreshDelegate {
    func doRefresh(refreshView: ZTRefreshView)
}

class ZTRefreshView: UIView {

    var scrollView:  UIScrollView!
    var viewHeight: CGFloat = 100
    var delegate: RefreshDelegate?
    var isAnimation = false
    var isRefreshing = false
    
    var progress: CGFloat = 0.0
    let radius: CGFloat = 40
    let lineWidth: CGFloat = 3
    
    var shapLayer = CAShapeLayer()
    
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        self.scrollView = scrollView
        scrollView.delegate = self
        
        //绘图
        shapLayer.fillColor = UIColor.clearColor().CGColor
        shapLayer.strokeColor = UIColor.redColor().CGColor
        layer.addSublayer(shapLayer)
    }
    
    convenience init(scrollView: UIScrollView) {
        if let sv = scrollView.superview {
            self.init(frame: CGRectMake(0, -120, sv.frame.size.width, 120), scrollView: scrollView)
        } else {
            self.init(frame: CGRectMake(0, -120, scrollView.frame.size.width, 120), scrollView: scrollView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginRefresh() {
        isRefreshing = true
        isAnimation = true
        
        UIView.animateWithDuration(0.3) {
            var inSet = self.scrollView.contentInset
            inSet.top += self.frame.size.height
            print(inSet)
            self.scrollView.contentInset.top = 120+64
        }
        
        shapLayer.path = UIBezierPath(arcCenter: CGPointMake(frame.size.width / 2, frame.size.height - 50), radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true).CGPath
        shapLayer.fillColor = UIColor.clearColor().CGColor
        shapLayer.lineWidth = lineWidth
        shapLayer.lineDashPattern = [2]
        
        let baseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        baseAnimation.duration = 0.8
        baseAnimation.fromValue = 0
        baseAnimation.toValue = 1
        baseAnimation.repeatDuration = 10
        shapLayer.addAnimation(baseAnimation, forKey: nil)
    }
    
    func endRefresh() {
        isRefreshing = false
        isAnimation = false
        
        UIView.animateWithDuration(0.5) {
            var inSet = self.scrollView.contentInset
            inSet.top -= self.frame.size.height
            self.scrollView.contentInset = inSet
            self.shapLayer.removeAllAnimations()
        }
    }
    
    func reDrawLayer(offY: CGFloat) {
        print(progress)
//        if !isAnimation {

            shapLayer.lineWidth = lineWidth
            shapLayer.lineDashPattern = [2,4,5]
            shapLayer.fillColor = UIColor.clearColor().CGColor
            
            let centerY = frame.size.height - offY + 1
            print("centerY\(centerY)")
            
            shapLayer.path = UIBezierPath(arcCenter: CGPointMake(frame.size.width / 2 , frame.size.height - 50), radius: radius * progress, startAngle: 0.0 , endAngle: CGFloat( 2 * M_PI ) * progress, clockwise: true).CGPath
            

//        }
    }

}

extension ZTRefreshView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offY = max(-1 * (scrollView.contentOffset.y + scrollView.contentInset.top), 0)
        progress = min(offY / self.frame.height, 1.0)
        print(progress)
        //更新progress的同时，重绘layer
        reDrawLayer(offY)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progress >= 1{
            delegate?.doRefresh(self)
            beginRefresh()
        }
    }
}
