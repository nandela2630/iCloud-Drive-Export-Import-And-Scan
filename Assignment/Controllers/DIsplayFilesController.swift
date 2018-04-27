//
//  DIsplayFilesController.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/26/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import UIKit

class DisplayFilesController: UIViewController {

    //MARK:IBOutlets
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var dispayTxtContent: UITextView!
    
    // MARK: Declarations
    var fileExtension : String?
    var fileUrl : URL?
    
    //MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let fileUrl = fileUrl else {
            GlobalClass.showAlert(title: Constants.alertTitle, message: "Failed to load", presentVW: self)
            return
        }

        if fileExtension == "pdf" || fileExtension == "docx"{
            
            topTitle.text = "PDF View"
            imageView.isHidden = true
            dispayTxtContent.isHidden = true
            //case PDF -> render
            webView.loadRequest(URLRequest(url: fileUrl))
    
        }else if fileExtension == "png" || fileExtension == "jpg" || fileExtension == "jpeg"{
            
            topTitle.text = "Image View"
            webView.isHidden = true
            dispayTxtContent.isHidden = true

                do {
                    let pickedData = try Data.init(contentsOf: fileUrl)
                    imageView.image = UIImage(data: pickedData)
                }catch {
                    GlobalClass.showAlert(title: Constants.alertTitle, message: "Failed to load", presentVW: self)
                }
            
        }else if fileExtension == "txt"{
            imageView.isHidden = true
            webView.isHidden = true
            dispayTxtContent.isHidden = false

            do {
                dispayTxtContent.text = try String(contentsOf: fileUrl)
            } catch {
                print("Failed reading from URL: \(fileUrl), Error: " + error.localizedDescription)
            }
            
        }else{
            
            dispayTxtContent.isHidden = true

            GlobalClass.showAlert(title: Constants.alertTitle, message: "Format viewer is not applicable", presentVW: self)

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
