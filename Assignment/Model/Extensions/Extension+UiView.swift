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
    
    //for views look
    func dropShadow() {
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOpacity = 0.6
            self.layer.shadowOffset = CGSize(width: -1, height: 1)
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
            
    }
}

extension URL {
    
    func getSize() -> String?{
        
        do {
            
            let fileAttribute: [FileAttributeKey : Any] = try FileManager.default.attributesOfItem(atPath: self.path)
            
            if let fileNumberSize: NSNumber = fileAttribute[FileAttributeKey.size] as? NSNumber {
                let byteCountFormatter: ByteCountFormatter = ByteCountFormatter()
                byteCountFormatter.countStyle = ByteCountFormatter.CountStyle.file
                
                byteCountFormatter.allowedUnits = ByteCountFormatter.Units.useKB
               
                return byteCountFormatter.string(fromByteCount: Int64(truncating: fileNumberSize))
                //byteCountFormatter.allowedUnits = ByteCountFormatter.Units.useMB
                //return byteCountFormatter.string(fromByteCount: Int64(fileNumberSize))
            }
            
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
        
        return nil

    }
}
