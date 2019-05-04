//
//  ShapeManager.swift
//  ShapesArt
//
//  Created by Nishant Sharma on 4/25/19.
//  Copyright © 2019 Developers. All rights reserved.
//

import UIKit
protocol DrawableViewDelegate {
    func viewClickedAtLocation(location: CGPoint)
}
class DrawableView: UIView, ShapeDragDelegate {
    var delegate: ShapeDragDelegate?
    var mainViewDelegate: DrawableViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func shapeAdded(shape: Shape) {
        let aShapeView: ShapeView = ShapeView.init(Shape: shape)
        aShapeView.delegate = self
        self.addSubview(aShapeView)
    }
    func shapeRemoved(shape: Shape)
    {
        var viewToRemove: UIView?
        for aShapeView in self.subviews {
            if (aShapeView as! ShapeView).shape?.isEqual(shape) ?? false {
                viewToRemove = aShapeView
            }
        }
        guard let view = viewToRemove else {
            return
        }
        (view as! ShapeView).delegate = nil
        (view as! ShapeView).removeFromSuperview()
    }
    func didBeginDraggingShape(shape: Shape, fromLocation point: CGPoint) {
        self.delegate?.didBeginDraggingShape(shape: shape, fromLocation: point)
    }
    
    func didDragShape(shape: Shape, toLocation point: CGPoint) {
        self.delegate?.didDragShape(shape: shape, toLocation: point)
    }
    
    func didEndDraggingShape(shape: Shape) {
        self.delegate?.didEndDraggingShape(shape: shape)
    }
    func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        self.mainViewDelegate?.viewClickedAtLocation(location: location)
    }
}
