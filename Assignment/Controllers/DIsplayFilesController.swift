//
//  DIsplayFilesController.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/26/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import UIKit

class DisplayFilesController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    var fileExtension : String?
    var fileUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if fileExtension == "pdf"{
        
            imageView.isHidden = true
            //optional, case PDF -> render
            if let pdfUrl = fileUrl {
                 webView.loadRequest(URLRequest(url: pdfUrl))
            }else{
                GlobalClass.showAlert(title: Constants.alertTitle, message: "Failed to load", presentVW: self)
            }
           
        }else if fileExtension == "png" || fileExtension == "jpg" || fileExtension == "jpeg"{
            
            webView.isHidden = true
            if let fileUrl = fileUrl {
                
                do {
                    let pickedData = try Data.init(contentsOf: fileUrl)
                    imageView.image = UIImage(data: pickedData)
                }catch {
                    GlobalClass.showAlert(title: Constants.alertTitle, message: "Failed to load", presentVW: self)

                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func popToBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }


}

extension DisplayFilesController : UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
}
