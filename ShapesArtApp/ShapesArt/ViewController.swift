//
//  ViewController.swift
//  DraggableView
//
//  Created by Nishant Sharma on 2019-04-24.
//  Copyright © 2019  All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var drawableView: DrawableView!
    
    var isDragging = false
    var edge: Edge = .topLeft
    var startLocation: CGPoint = .zero
    var trailingStart: CGFloat = 0
    var bottomStart: CGFloat = 0
    var leadingStart: CGFloat = 0
    var topStart: CGFloat = 0
    var constants = [CGFloat]()
    var dragStart = CGPoint.zero
    var shapeStartPosition = CGPoint.zero

    let fingerShape: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: -20, y: -20), size: CGSize(width: 60, height: 60))).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 3
        shape.strokeColor = UIColor.red.withAlphaComponent(0.5).cgColor
        return shape
    }()
    
    let animation = CABasicAnimation(keyPath: "position")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constants = [top.constant, trailing.constant, bottom.constant, leading.constant]
        
        fingerShape.isHidden = true
        view.layer.addSublayer(fingerShape)
        
        self.drawableView.delegate = self
    }
    
    func moveFinger(to position: CGPoint) {
        animation.fromValue = position
        animation.toValue = position
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        fingerShape.add(animation, forKey: "position")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        startLocation = touches.first!.location(in: view)
        if leading.constant-40...leading.constant+40 ~= startLocation.x && top.constant+view.safeAreaInsets.top-40...top.constant+view.safeAreaInsets.top+40 ~= startLocation.y {
            isDragging = true
            edge = .topLeft
            leadingStart = leading.constant
            topStart = top.constant
            fingerShape.isHidden = false
            moveFinger(to: startLocation)
        }
        else if (width-trailing.constant-40)...(width-trailing.constant+40) ~= startLocation.x && top.constant+view.safeAreaInsets.top-40...top.constant+view.safeAreaInsets.top+40 ~= startLocation.y {
            isDragging = true
            edge = .topRight
            trailingStart = trailing.constant
            topStart = top.constant
            fingerShape.isHidden = false
            moveFinger(to: startLocation)
        }
        else if (width-trailing.constant-40)...(width-trailing.constant+40) ~= startLocation.x &&
            (height-bottom.constant-40)...(height-bottom.constant+40) ~= startLocation.y {
            isDragging = true
            edge = .bottomRight
            trailingStart = trailing.constant
            bottomStart = bottom.constant
            fingerShape.isHidden = false
            moveFinger(to: startLocation)
        }
        else if leading.constant-40...leading.constant+40 ~= startLocation.x &&
            (height-bottom.constant-40)...(height-bottom.constant+40) ~= startLocation.y {
            isDragging = true
            edge = .bottomLeft
            leadingStart = leading.constant
            bottomStart = bottom.constant
            fingerShape.isHidden = false
            moveFinger(to: startLocation)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
        fingerShape.isHidden = true
        
        if overlayView.frame.width == 0 || overlayView.frame.height == 0 {
            top.constant = constants[0]
            trailing.constant = constants[1]
            bottom.constant = constants[2]
            leading.constant = constants[3]
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
        fingerShape.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDragging {
            guard let location = touches.first?.location(in: view) else { return }
            moveFinger(to: location)
            let deltaX = startLocation.x -  location.x
            let deltaY = startLocation.y - location.y
            switch edge {
            case .topLeft:
                leading.constant = max(20, leadingStart - deltaX)
                top.constant = max(20, topStart - deltaY)
            case .topRight:
                trailing.constant = max(20, trailingStart + deltaX)
                top.constant = max(20, topStart - deltaY)
            case .bottomRight:
                trailing.constant = max(20, trailingStart + deltaX)
                bottom.constant = max(20, bottomStart + deltaY)
            case .bottomLeft:
                leading.constant = max(20, leadingStart - deltaX)
                bottom.constant = max(20, bottomStart + deltaY)
            }
        }
    }
    
    @IBAction func addShape(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "PopoverViewController") as? PopoverViewController else {
            return
        }
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = controller.preferredSize
        controller.delegate = self
        if let popover = controller.popoverPresentationController {
            popover.barButtonItem = sender as? UIBarButtonItem
            popover.delegate = self
        }
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ViewController: PopoverItemDelegate {
    func didSelectShape(shape: ShapeType) {
        switch shape {
        case .Ellipse:
            let ellipse = EllipseShape()
            self.drawableView.shapeAdded(shape: ellipse)
        case .Rectangle:
            let rectangle = RectangleShape()
            self.drawableView.shapeAdded(shape: rectangle)
        case .Triangle:
            let triangle = TriangleShape()
            self.drawableView.shapeAdded(shape: triangle)
        }
    }
}

extension ViewController: ShapeDragDelegate {
    
    func didBeginDraggingShape(shape: Shape, fromLocation point: CGPoint) {
        // Save the initial mousedown location and shape position.
        // As we drag, we will calculate each drag step as an absolute offset from the start
        // This allows us to avoid drift we would see if we simply followed the x/y deltas in the events.
        // Warning: we assume here that anothe didBeginDraggingShape: will not be received until
        // the current drag is complete. but it'd be wise to check/enforce this.
        dragStart = point
        shapeStartPosition = shape.position
        
//        [[self undoManager] disableUndoRegistration];
    }
    
    func didDragShape(shape: Shape, toLocation pt: CGPoint) {
        var point = pt
        let oldPosition = shape.position
        point.x -= dragStart.x;
        point.y -= dragStart.y;
        point.x += shapeStartPosition.x;
        point.y = shapeStartPosition.y + point.y;
        
        if __CGPointEqualToPoint(pt, oldPosition) == false {
            shape.setPosition(position: point)
        }
    }
    
    func didEndDraggingShape(shape: Shape) {
        
    }
}

extension ViewController: DrawableViewDelegate {
    func viewClickedAtLocation(location: CGPoint) {
//        SAShape *newShape = [SAShape shapeWithType:self.document.currenDocumentModel.currentShapeType];
//        newShape.strokeWidth = self.document.currenDocumentModel.currentStrokeWidth;
//        newShape.fillColor = self.document.currenDocumentModel.currentFillColor;
//        newShape.strokeColor = self.document.currenDocumentModel.currentStrokeColor;
//        [self addShape:newShape atLocation:location];
    }
}

