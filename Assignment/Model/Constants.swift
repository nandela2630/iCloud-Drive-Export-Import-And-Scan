//
//  Constants.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/25/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import Foundation
import UIKit

var importUrlsArray = [BaseObj]()

struct Constants {

    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let welcomeStoryboard = UIStoryboard(name: "Welcome", bundle: nil)

    //For Camera Permissions / If user selected Don't allow
    static let alertTitle = "Alert"
    static let allowCameraTitle = "Important!"
    static let allowCamera = "Camera access required for capturing photos!"
    static let allowCamerForQRScan = "Please allow camera access for QR Scanning"
    static let allowCameraInstructs = "\n\n⚙️ 1. Go to the settings from the home screen of your Phone \n\n📱 2. Select privacy from the options \n\n📷  3. Set 'Allow Camera' to On for valU App."
}
