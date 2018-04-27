//
//  ViewController.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/25/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationItem.setHidesBackButton(true, animated:true)
         self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    // MARK:- IBActions
    //Scan
    @IBAction func scanAction(_ sender: UIButton) {
        GlobalClass.pushToView(from: self, withIdentifier: "ScanViewController")
    }
    
    //iCloud
    @IBAction func fetchFromiCloud(_ sender: UIButton) {
        GlobalClass.pushToView(from: self, withIdentifier: "iCloudExportImportVC")
    }
    
    //Take a Tour
    @IBAction func takeATour(_ sender: UIButton) {
        GlobalClass.pushToWelcomeStoryBoard(from: self, withIdentifier: "PageContentVC")
    }
    
}




















/*let filemgr = FileManager.default
 
 ubiquityURL = filemgr.url(forUbiquityContainerIdentifier: nil)
 
 guard ubiquityURL != nil else {
 //GlobalClass.showAlert(title: "Unable to access iCloud Account", message: "Open the Settings app and enter your Apple ID into iCloud settings", presentVW: self)
 return
 }
 
 ubiquityURL = ubiquityURL?.appendingPathComponent(
 "Documents/")
 
 metaDataQuery = NSMetadataQuery()
 
 metaDataQuery?.predicate =
 NSPredicate(format: "%K like '*'",
 NSMetadataItemFSNameKey)
 
 metaDataQuery?.searchScopes =
 [NSMetadataQueryUbiquitousDocumentsScope]
 
 NotificationCenter.default.addObserver(self,
 selector: #selector(
 self.metadataQueryDidFinishGathering),
 name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
 object: metaDataQuery!)
 
 metaDataQuery!.start()*/
