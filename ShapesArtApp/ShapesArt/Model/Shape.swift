//
//  Shape.swift
//  ShapesArt
//
//  Created by Nishant Sharma on 4/24/19.
//  Copyright © 2019 Developers. All rights reserved.
//

import UIKit
import CoreGraphics

enum ShapeType: String {
    case Rectangle = "Rectangle"
    case Ellipse = "Ellipse"
    case Triangle = "Triangle"
}
enum ShapeNotification: Notification.Name {    
    case shapeChangedNotification = "ShapeChangedNotification"
}
extension Notification.Name: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}
class Shape: NSObject {
    var position: CGPoint
    var size: CGSize
    var strokeWidth: CGFloat
    var shouldFill: Bool
    var shouldStroke: Bool
    var fillColor: UIColor
    var strokeColor: UIColor
    var drawableModel: DrawableViewModel?
    
    override init() {
        self.position = CGPoint.init(x: 100, y: 100)
        self.size = CGSize.init(width: 50, height: 50)
        self.shouldFill = true
        self.shouldStroke = true
        self.fillColor = UIColor.red
        self.strokeColor = UIColor.green
        self.strokeWidth = 5
    }
    
    func setupContextForDrawing(context: CGContext) {
    
    }
    
    func paddedFrame() -> CGRect {
        let padding: CGFloat = 5.0
        return CGRect.init(x: self.position.x - self.size.width / 2 - padding,
                           y: self.position.y - self.size.height / 2 - padding,
                           width: self.size.width + 2 * padding,
                           height: self.size.height + 2 * padding)
    }
    
    func setPosition(position: CGPoint) {
        self.position = position
        NotificationCenter.default.post(name: ShapeNotification.shapeChangedNotification.rawValue, object: self)
    }
    
    func createDrawingPath() -> CGPath? {
    // Live to be overriden.
        NSException.raise(.internalInconsistencyException, format: "-createDrawingPath hasn't been %@.", arguments: getVaList(["overridden"]))
        return nil
    }
}
