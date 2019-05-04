//
//  RectangleShape.swift
//  ShapesArt
//
//  Created by Nishant Sharma on 4/24/19.
//  Copyright © 2019 Developers. All rights reserved.
//

import UIKit

class RectangleShape: Shape {
    override func createDrawingPath() -> CGPath
    {
        let paddedFrame: CGRect = self.paddedFrame()
        let centeredFrame: CGRect = CGRect.init(x: (paddedFrame.size.width - self.size.width) / 2, y: (paddedFrame.size.height - self.size.height) / 2, width: self.size.width, height: self.size.height)
        return CGPath.init(rect: centeredFrame, transform: nil)
    }

}
