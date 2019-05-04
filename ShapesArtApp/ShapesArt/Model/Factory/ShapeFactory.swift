//
//  ShapeFactory.swift
//  ShapesArt
//
//  Created by Nishant Sharma on 4/24/19.
//  Copyright © 2019 Developers. All rights reserved.
//

import UIKit

extension Shape {
    func shapeWithType(aType: ShapeType) -> Shape? {
        var shape: Shape?
        switch (aType) {
        case .Ellipse:
            shape = EllipseShape()
        case .Rectangle:
            shape = RectangleShape()
        case .Triangle:
            shape = TriangleShape()
        }
        return shape
    }
}
