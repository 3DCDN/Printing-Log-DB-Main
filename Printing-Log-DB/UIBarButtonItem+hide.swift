//
//  UIBarButtonItem+hide.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-07-12.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
