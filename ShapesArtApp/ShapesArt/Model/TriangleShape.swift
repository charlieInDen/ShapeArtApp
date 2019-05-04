//
//  TriangleShape.swift
//  ShapesArt
//
//  Created by Nishant Sharma on 4/24/19.
//  Copyright © 2019 Developers. All rights reserved.
//

import UIKit

class TriangleShape: Shape {
    override func createDrawingPath() -> CGPath
    {
        let mutablePath = CGMutablePath.init()
        let paddedFrame: CGRect = self.paddedFrame()
        let centeredFrame: CGRect = CGRect.init(x: (paddedFrame.size.width - self.size.width) / 2, y: (paddedFrame.size.height - self.size.height) / 2, width: self.size.width, height: self.size.height)
        mutablePath.move(to: CGPoint.init(x: centeredFrame.minX, y: centeredFrame.maxY))
        mutablePath.addLine(to: CGPoint.init(x: centeredFrame.maxX, y: centeredFrame.maxY))
        mutablePath.addLine(to: CGPoint.init(x: centeredFrame.midX, y: centeredFrame.minY))
        mutablePath.closeSubpath()
        let triangle: CGPath = mutablePath.copy()!
        return triangle
    }
}

