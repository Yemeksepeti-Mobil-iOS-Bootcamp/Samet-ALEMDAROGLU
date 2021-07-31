//
//  UIImageView+Ext.swift
//  BusTicketApp
//
//  Created by ALEMDAR on 29.07.2021.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
}
