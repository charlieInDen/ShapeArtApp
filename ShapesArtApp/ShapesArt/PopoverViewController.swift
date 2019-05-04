//
//  PopoverViewController.swift
//  ShapesArt
//
//  Created by Uday Kiran Veginati on 4/30/19.
//  Copyright © 2019 Developers. All rights reserved.
//

import UIKit

protocol PopoverItemDelegate: class {
    func didSelectShape(shape: ShapeType)
}

class PopoverViewController: UIViewController {
    
    let shapes: [ShapeType] = [.Ellipse, .Rectangle, .Triangle]
    weak var delegate: PopoverItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    var preferredSize: CGSize {
        get {
            return CGSize(width: 300.0, height: Double(shapes.count * 44))
        }
    }
}

extension PopoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shapes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shapes[indexPath.row].rawValue
        return cell
    }
}

extension PopoverViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectShape(shape: shapes[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

