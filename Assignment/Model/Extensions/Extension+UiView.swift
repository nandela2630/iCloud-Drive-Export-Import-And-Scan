//
//  Extension+UiView.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/26/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
        func dropShadow() {
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOpacity = 0.6
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
            
        }
}
