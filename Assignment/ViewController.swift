//
//  ViewController.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/25/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import UIKit
import MobileCoreServices

class MyDocument: UIDocument
{
    var userText: String? = "Some Sample Text"
    
    var userImage : UIImage? = UIImage(named:"")
    
    override func contents(forType typeName: String) throws -> Any
    {
        if let content = userText  {
            
            let length =
                content.lengthOfBytes(using: String.Encoding.utf8)
            
            return NSData(bytes:content, length: length)
            
        }else{
            
            return Data()
        }
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws
    {
        if let userContent = contents as? Data
        {
            userText = (NSString(bytes: (contents as AnyObject).bytes,
                                 length: userContent.count,
                                 encoding: String.Encoding.utf8.rawValue)! as String)
        }
    }
    
    
}

/*
 let filemgr = FileManager.default
 
 ubiquityURL = filemgr.url(forUbiquityContainerIdentifier: nil)
 
 guard ubiquityURL != nil else {
 print("Unable to access iCloud Account")
 print("Open the Settings app and enter your Apple ID into iCloud settings")
 return
 }
 
 ubiquityURL = ubiquityURL?.appendingPathComponent(
 "Documents/savefile.txt")
 
 metaDataQuery = NSMetadataQuery()
 
 metaDataQuery?.predicate =
 NSPredicate(format: "%K like 'savefile.txt'",
 NSMetadataItemFSNameKey)
 
 metaDataQuery?.searchScopes =
 [NSMetadataQueryUbiquitousDocumentsScope]
 
 NotificationCenter.default.addObserver(self,
 selector: #selector(
 self.metadataQueryDidFinishGathering),
 name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
 object: metaDataQuery!)
 
 metaDataQuery!.start()
 
 @objc func metadataQueryDidFinishGathering(notification: NSNotification) -> Void
 {
 let query: NSMetadataQuery = notification.object as! NSMetadataQuery
 
 query.disableUpdates()
 
 NotificationCenter.default.removeObserver(self,
 name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
 object: query)
 
 query.stop()
 
 
 if query.resultCount == 1 {
 
 let resultURL = query.value(ofAttribute: NSMetadataItemURLKey,
 forResultAt: 0) as! URL
 
 document = MyDocument(fileURL: resultURL as URL)
 
 document?.open(completionHandler: {(success: Bool) -> Void in
 if success {
 print("iCloud file open OK")
 //self.textView.text = self.document?.userText
 self.ubiquityURL = resultURL as URL
 } else {
 print("iCloud file open failed")
 }
 })
 } else {
 document = MyDocument(fileURL: ubiquityURL!)
 
 document?.save(to: ubiquityURL!,
 for: .forCreating,
 completionHandler: {(success: Bool) -> Void in
 if success {
 print("iCloud create OK")
 } else {
 print("iCloud create failed")
 }
 })
 }
 }*/
var importUrlsArray = [BaseObj]()

class ViewController: UIViewController {

    var document: MyDocument?
    var documentURL: URL?
    var ubiquityURL: URL?
    var metaDataQuery: NSMetadataQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let filemgr = FileManager.default
        
        ubiquityURL = filemgr.url(forUbiquityContainerIdentifier: nil)
        
        guard ubiquityURL != nil else {
            GlobalClass.showAlert(title: "Unable to access iCloud Account", message: "Open the Settings app and enter your Apple ID into iCloud settings", presentVW: self)
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

        metaDataQuery!.start()
        
        /* if let url = Bundle.main.url(forResource: "Your Already Created Package", withExtension: "your-package-extension") {
         importHandler(url, .copy)
         } else {
         importHandler(nil, .none)
         }
         
         
         if let filepath = Bundle.main.path(forResource: "example", ofType: "txt") {
         do {
         let contents = try String(contentsOfFile: filepath)
         print(contents)
         } catch {
         // contents could not be loaded
         }
         } else {
         // example.txt not found!
         }
         
         
         var pdf = (FileManager.default.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last as? NSURL
         pdf = pdf?.URLByAppendingPathComponent( "ST_Business%20Times_07022016.pdf")
         let req = NSURLRequest(URL: pdf)
         webView.loadRequest(req)
         
          let data = try Data(contentsOf: pdfUrl)
         webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfUrl.deletingLastPathComponent())

         */
        
     
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .cachesDirectory, in: .allDomainsMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
            
            print(fileURLs)
            
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationItem.setHidesBackButton(true, animated:true)
         self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @objc func metadataQueryDidFinishGathering(notification: NSNotification) -> Void
    {
        let query: NSMetadataQuery = notification.object as! NSMetadataQuery
        
        query.disableUpdates()
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSMetadataQueryDidFinishGathering,
                                                  object: query)
        
        query.stop()
        
        
        if query.resultCount == 1 {
            
            let resultURL = query.value(ofAttribute: NSMetadataItemURLKey,
                                        forResultAt: 0) as! URL
            
            document = MyDocument(fileURL: resultURL as URL)
            
            document?.open(completionHandler: {(success: Bool) -> Void in
                if success {
                    print("iCloud file open OK")
                    //self.displayLbl.text = self.document?.userText
                    self.ubiquityURL = resultURL as URL
                    
                    print(self.ubiquityURL as Any)
                    
                    
                    do{
                        let pickedData = try Data.init(contentsOf: self.ubiquityURL!)
                    
                    print(pickedData)
                        
                           print(NSString(bytes: (pickedData as AnyObject).bytes,
                                                length: pickedData.count,
                                                encoding: String.Encoding.utf8.rawValue) as String? as Any)
                        
                    
                    }catch {
                        
                        
                        
                    }
                } else {
                    print("iCloud file open failed")
                }
            })
        } else {
            document = MyDocument(fileURL: ubiquityURL!)
            
            document?.save(to: ubiquityURL!,
                           for: .forCreating,
                           completionHandler: {(success: Bool) -> Void in
                            if success {
                                print("iCloud create OK")
                            } else {
                                print("iCloud create failed")
                            }
            })
        }
    }
    
   
    
    // MARK:- IBAction
    @IBAction func scanAction(_ sender: UIButton) {
        GlobalClass.pushToView(from: self, withIdentifier: "ScanViewController")
    }
    
    
    
    @IBAction func fetchFromiCloud(_ sender: UIButton) {
        
        GlobalClass.pushToView(from: self, withIdentifier: "iCloudExportImportVC")
        
            //importFromiCloud()
        
        let cloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)
        print(cloudURL as Any)
        
        let files = FileManager.default.url(forUbiquityContainerIdentifier: "")?.appendingPathComponent("Documents")
        
        print(files as Any)
        
//        if CloudDataManager.isCloudEnabled() {
//
//             CloudDataManager.copyFileToLocal()
//        }else{
//
//            GlobalClass.showAlert(title: Constants.allowCameraTitle, message: "\(Constants.allowCamerForQRScan)\(Constants.allowCameraInstructs)", presentVW: self)
//
//        }
        
    }
    
    @IBAction func takeATour(_ sender: UIButton) {
        
        GlobalClass.pushToWelcomeStoryBoard(from: self, withIdentifier: "PageContentVC")
    }
    


}




// MARK:- Functions
extension ViewController {
    
    func importFromiCloud(){
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
        
        //importMenu.delegate = self
        
        importMenu.modalPresentationStyle = .formSheet
        
        self.present(importMenu, animated: true) {
            
           
        }
    }
    
   
}

/* if FileManager.default.fileExists(atPath: urls[0].path) {
 
 GlobalClass.showAlert(title: "Alert", message: "Already imported", presentVW: self)
 
 }else{
 
 
 }*/


struct DocumentsURls{
    
    static let documentsDirectoryURL : NSURL? = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last! as NSURL
    
    static let iCloudDocumentsURL : NSURL? = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") as NSURL?
}

class CloudDataManager
{
    /*
     // MARK: - Check if iCloud sync is enabled
     */
    
    class func isCloudEnabled() -> Bool
    {
        print("CloudDataManager > isCloudEnabled")
        print(DocumentsURls.iCloudDocumentsURL as Any)
        if DocumentsURls.iCloudDocumentsURL != nil
        {
            print("iCloud sync is enabled")
            
            return true
        }
        else
        {
            print("iCloud sync is disabled")
            
            return false
        }
    }
    
    
    /*
     // MARK: - Delete all files in a Directory
     */
    
    class func deleteFilesInDirectory(url: NSURL?)
    {
        print("CloudDataManager > deleteFilesInDirectory")
        
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url!.path!)
        while let file = enumerator?.nextObject() as? String
        {
            do
            {
                try fileManager.removeItem(at: url!.appendingPathComponent(file)!)
                print("Files deleted")
            }
            catch let error as NSError
            {
                print("Failed to delete files : \(error)")
            }
        }
    }
    
    
    /*
     // MARK: - Copy all files in DocumentsDirectory to iCloud
     */
    
    func copyFileToCloud()
    {
        print("CloudDataManager > copyFileToCloud")
        
        if CloudDataManager.isCloudEnabled()
        {
            CloudDataManager.deleteFilesInDirectory(url: DocumentsURls.iCloudDocumentsURL!)
            
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsURls.documentsDirectoryURL!.path!)
            while let file = enumerator?.nextObject() as? String
            {
                do
                {
                    try fileManager.copyItem(at: DocumentsURls.documentsDirectoryURL!.appendingPathComponent(file)!,
                                             to: DocumentsURls.iCloudDocumentsURL!.appendingPathComponent(file)!)
                    
                    print("Copied to iCloud")
                }
                catch let error as NSError
                {
                    print("Failed to copy file to Cloud : \(error)")
                }
            }
        }
        else
        {
            print("iCloud sync disabled")
        }
    }
    
    
    /*
     // MARK: - Copy all files in iCloud to DocumentsDirectory
     */
    
    class func copyFileToLocal()
    {
        print("CloudDataManager > copyFileToLocal")
        
        if CloudDataManager.isCloudEnabled()
        {
            CloudDataManager.deleteFilesInDirectory(url: DocumentsURls.documentsDirectoryURL!)
            
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsURls.iCloudDocumentsURL!.path!)
            print(enumerator as Any)

            while let file = enumerator?.nextObject() as? String
            {
                do
                {
                    print(file)
                    
                    try fileManager.copyItem(at: DocumentsURls.iCloudDocumentsURL!.appendingPathComponent(file)!,
                                             to: DocumentsURls.documentsDirectoryURL!.appendingPathComponent(file)!)
                    
                    print("Copied to local dir")
                }
                catch let error as NSError
                {
                    print("Failed to copy file to local dir : \(error)")
                }
            }
        }
        else
        {
            print("iCloud sync disabled")
        }
    }
}


class BaseObj : NSObject {
    
    var exTnsion : String?
    var fileName: String?
    var pathUrl : URL?
}
