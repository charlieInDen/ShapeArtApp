//
//  ShapeMainModel.swift
//  ShapesArt
//
//  Created by Nishant Sharma on 4/25/19.
//  Copyright © 2019 Developers. All rights reserved.
//

import UIKit
protocol ShapeDrawDelegate {
    func shapeAdded(shape: Shape)
    func shapeRemoved(shape: Shape)
}

class DrawableViewModel: NSObject {
    var shapeDelegate: ShapeDrawDelegate?
    var undoManager: UndoManager?
    var shapes: [Shape]?
    var currentFillColor: UIColor?
    var currentStrokeColor: UIColor?
    var currentShapeType: ShapeType = ShapeType.Rectangle
    var currentStrokeWidth: CGFloat?
    
    override init() {
        self.shapes = []
        self.currentFillColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.currentStrokeColor = UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        self.currentShapeType = .Rectangle
        self.currentStrokeWidth = 5
    }
    
    func addShape(shape: Shape, atLocation location: CGPoint)
    {
        print("Shapes count: %lu", self.shapes?.count ?? 0)
        shape.position = location
        shape.strokeColor = self.currentStrokeColor ?? UIColor.red
        shape.fillColor = self.currentFillColor ?? UIColor.green
        shape.strokeWidth = self.currentStrokeWidth ?? 5
        shape.shouldFill = true
        shape.shouldStroke = true
        shape.drawableModel = self
        self.undoManager?.registerUndo(withTarget: self, selector: #selector(removeShape(shape:)), object: shape)
        self.shapes?.append(shape)
        self.shapeDelegate?.shapeAdded(shape: shape)
    }
    @objc func removeShape(shape: Shape)
    {
        guard let drawableViewModel = self.undoManager?.prepare(withInvocationTarget: self) as? DrawableViewModel else  {
            return
        }
        drawableViewModel.addShape(shape: shape, atLocation: shape.position)
        self.shapes?.removeAll(where: { (argShape) -> Bool in
            return argShape == shape
        })
        self.shapeDelegate?.shapeRemoved(shape: shape)
    }
    
    func setShapeDrawableDelegate(drawableDelegate:ShapeDrawDelegate)
    {
        shapeDelegate = drawableDelegate
        for shape in self.shapes ?? [] {
            self.shapeDelegate?.shapeAdded(shape: shape)
        }
    }

}
