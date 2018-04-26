//
//  GlobalClassFile.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/25/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import Foundation


import UIKit
import AVFoundation // For Camera Permissions


class GlobalClass {

    class func showAlert(title:String, message: String, presentVW:UIViewController) {
        
        let alertToShow = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        
        alertToShow.addAction(dismiss)
        
        presentVW.present(alertToShow, animated: true, completion: nil)

    }
    
    class func pushToView(from:UIViewController, withIdentifier:String){
        let scanVC = Constants.mainStoryboard.instantiateViewController(withIdentifier: withIdentifier) 
        from.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    class func pushToWelcomeStoryBoard(from:UIViewController, withIdentifier:String){
        let scanVC = Constants.welcomeStoryboard.instantiateViewController(withIdentifier: withIdentifier)
        from.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    class func checkCameraStatus(completed: @escaping (_ returnBool:Bool) ->()){
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            completed(true)
            
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    // User granted
                    completed(true)
                    
                }else {
                    // User Rejected
                    completed(false)
                    
                    
                }
            })
        }
    }
    
}

