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
    var viewHeight = 100
    var delegate: RefreshDelegate?
    var isAnimation = false
    var isRefreshing = false
    
    var progress: CGFloat = 0.0
    let radius: CGFloat = 20
    let lineWidth: CGFloat = 4
    
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
            self.init(frame: CGRectMake(0, -80, sv.frame.size.width, 80), scrollView: scrollView)
        } else {
            self.init(frame: CGRectMake(0, -80, scrollView.frame.size.width, 80), scrollView: scrollView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginRefresh() {
        isRefreshing = true
        isAnimation = true
        
        UIView.animateWithDuration(0.5) { 
            var inSet = self.scrollView.contentInset
            inSet.top += self.frame.size.height
            self.scrollView.contentInset = inSet
        }
        
        shapLayer.path = UIBezierPath(arcCenter: CGPointMake(frame.size.width / 2, frame.size.height - 25), radius: radius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true).CGPath
        shapLayer.fillColor = UIColor.clearColor().CGColor
        shapLayer.lineWidth = lineWidth
        shapLayer.lineDashPattern = [5]
        
        let baseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        baseAnimation.duration = 2
        baseAnimation.fromValue = 0
        baseAnimation.toValue = 1
        baseAnimation.repeatDuration = 5
        shapLayer.addAnimation(baseAnimation, forKey: nil)
    }
    
    func endRefresh() {
        isRefreshing = false
        isAnimation = false
        
        UIView.animateWithDuration(3) {
            var inSet = self.scrollView.contentInset
            inSet.top -= self.frame.size.height
            self.scrollView.contentInset = inSet
        }
    }
    
    func reDrawLayer(offY: CGFloat) {
        print(isAnimation)
        if !isAnimation {

            shapLayer.lineWidth = lineWidth
            shapLayer.lineDashPattern = [5]
            shapLayer.fillColor = UIColor.clearColor().CGColor
            
            let centerY = frame.size.height - 25
            shapLayer.path = UIBezierPath(arcCenter: CGPointMake(frame.size.width / 2 , centerY), radius: radius * progress, startAngle: 0.0 , endAngle: CGFloat( 2 * M_PI) * progress, clockwise: true).CGPath
        }
    }

}

extension ZTRefreshView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offY = max(-1 * (scrollView.contentOffset.y + scrollView.contentInset.top), 0)
        progress = min(offY / self.frame.height, 1.0)
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
