//
//  UIBarButtonItem+hide.swift
//  Printing-Log-DB
//
//  Created by Rich St.Onge on 2021-07-12.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
