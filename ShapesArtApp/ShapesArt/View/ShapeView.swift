//
//  ShapeView.swift
//  ShapesArt
//
//  Created by Nishant Sharma on 4/24/19.
//  Copyright © 2019 Developers. All rights reserved.
//

import UIKit
protocol ShapeDragDelegate {
    func didBeginDraggingShape(shape: Shape, fromLocation point: CGPoint)
    func didDragShape(shape: Shape, toLocation point: CGPoint)
    func didEndDraggingShape(shape: Shape)
}

class ShapeView: UIView {

    static var kResizeThumbSize:CGFloat = 44.0
    
    var isResizingBottomRightCorner:Bool = false
    var isResizingLeftCorner:Bool = false
    var isResizingRightCorner:Bool = false
    var isResizingBottomLeftCorner:Bool = false
    
    var touchStart = CGPoint.zero
    
    var delegate: ShapeDragDelegate?
    var shape: Shape?
    init(Shape aShape: Shape) {
        super.init(frame: aShape.paddedFrame())
        NotificationCenter.default.addObserver(self, selector: #selector(shapeChanged),
                                               name: ShapeNotification.shapeChangedNotification.rawValue, object: aShape)
        self.shape = aShape
        self.backgroundColor = UIColor.clear
        let panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(moveShape(sender:)))
        self.addGestureRecognizer(panRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        context.saveGState()
        guard let path: CGPath = self.shape?.createDrawingPath() else {
            return
        }
        if self.shape?.shouldFill ?? false {
            context.addPath(path)
            context.setFillColor(self.shape?.fillColor.cgColor ?? UIColor.red.cgColor)
            context.fillPath()
        }
        
        if self.shape?.shouldStroke ?? false {
            context.addPath(path)
            context.setStrokeColor(self.shape?.strokeColor.cgColor ?? UIColor.gray.cgColor)
            context.setLineWidth(self.shape?.strokeWidth ?? 0.1)
            context.strokePath()
        }
        context.restoreGState()
    }
    @objc func shapeChanged() {
        self.frame = self.shape?.paddedFrame() ?? CGRect.init(x: 0, y: 0, width: 10, height: 10) //DEFAULT VALUE
    }
    @objc func moveShape(sender: UIPanGestureRecognizer)
    {
        let location: CGPoint = sender.location(in: self.superview)
        if sender.state == .began {
            self.delegate?.didBeginDraggingShape(shape: self.shape!, fromLocation: location)
        }else if sender.state == .changed {
            self.delegate?.didDragShape(shape: self.shape!, toLocation: location)
        }else if sender.state == .ended {
            self.delegate?.didEndDraggingShape(shape: self.shape!)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name:  ShapeNotification.shapeChangedNotification.rawValue, object: self.shape)
    }
}
