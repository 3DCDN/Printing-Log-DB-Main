//
//  UIView+addBorder.swift
//  Printing-Log-DB
//
//  Created by Rich St.Onge on 2021-07-12.
//

import UIKit

extension UIView {
    func addBorder(width: CGFloat, radius: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    
    func noBorder() {
        self.layer.borderWidth = 0.0
    }
}
