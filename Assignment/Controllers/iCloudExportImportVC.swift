//
//  iCloudExportImportVC.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/26/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import UIKit
import MobileCoreServices

class iCloudExportImportVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var takeAPicVW: UIView!
    @IBOutlet weak var smileLabel: UILabel!
    @IBOutlet weak var dispImgDummy: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadToiCloudBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: Declarations
    let imagePicker = UIImagePickerController()
    var imageViewObject  = UIImageView()
    var imageUrl : URL?
    var filterSearchArray = [BaseObj]()

    // MARK: VIEWS
    override func viewDidLoad() {
        super.viewDidLoad()
    
        takeAPicVW.isHidden = false
        uploadToiCloudBtn.isHidden = false
        tableView.isHidden = true
        searchBar.isHidden = true
        searchBar.delegate = self
        
        //Hide bottom lines in uitableview
        tableView.tableFooterView = UIView()
        takeAPicVW.dropShadow()
        
        //Tap Gesture to UIView for image picker
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImage(_:)))
        takeAPicVW.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK:- IBACTIONS
    @IBAction func importFromiCloud(_ sender: UIButton) {
        takeAPicVW.isHidden = true
        tableView.isHidden = false
        searchBar.isHidden = false
        uploadToiCloudBtn.isHidden = true
        
        importFromiCloud()
        
    }
    
    @IBAction func exportToiCloud(_ sender: UIButton) {
        takeAPicVW.isHidden = false
        tableView.isHidden = true
        searchBar.isHidden = true
        uploadToiCloudBtn.isHidden = false
    }
    
    @IBAction func exportToiCloudAction(_ sender: UIButton) {
        
        guard let url = imageUrl else {
            GlobalClass.showAlert(title: Constants.alertTitle, message: "Please tap on view and choose image", presentVW: self)
            return
        }
            
        exportToiCloud(fileUrl: url)
        
        
    }
    
    @IBAction func popToBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: De Init
    deinit {
        filterSearchArray.removeAll()
        importUrlsArray.removeAll()
    }
    
}

// MARK: UITableViewDelegates
extension iCloudExportImportVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterSearchArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = tableView.dequeueReusableCell(withIdentifier: "iCloudFileCell", for: indexPath) as! DisplayImportFilesCell
        
        let selectObj = filterSearchArray[indexPath.row]
        cell.fileName.text = selectObj.fileName ?? "NA"
        cell.filleExtension.text = "\(selectObj.pathUrl?.getSize() ?? "0") \(selectObj.exTnsion ?? "NA")"
        
        if selectObj.exTnsion == "jpg" || selectObj.exTnsion == "png" || selectObj.exTnsion == "jpeg"{
        
            do {
                let pickedData = try Data.init(contentsOf: (selectObj.pathUrl)!)
                cell.dispImgVW.image = UIImage(data: pickedData)
            }catch {
        
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let selectObj = filterSearchArray[indexPath.row]
        print(selectObj.fileName as Any)
        let dispVC = Constants.mainStoryboard.instantiateViewController(withIdentifier: "DisplayFilesController") as! DisplayFilesController
        dispVC.fileExtension = selectObj.exTnsion
        dispVC.fileUrl = selectObj.pathUrl
        self.navigationController?.pushViewController(dispVC, animated: true)
       
    }
}

// MARK:- UIDocumentPickerDelegates
extension iCloudExportImportVC : UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if controller.documentPickerMode == .import {
            
            let baseObj = BaseObj()
            
            let pathExt = urls[0].pathExtension
            let fileName = URL(fileURLWithPath: urls[0].absoluteString).deletingPathExtension().lastPathComponent
            baseObj.pathUrl = urls[0]
            baseObj.fileName = fileName
            
            if pathExt == "jpg" || pathExt == "png"{
                
                baseObj.exTnsion = pathExt
                
            }else if pathExt == "pdf"{
                
                baseObj.exTnsion = pathExt
                
                
            }else if pathExt == "txt"{
                
                baseObj.exTnsion = pathExt
            }
            
            importUrlsArray.append(baseObj)
            filterSearchArray = importUrlsArray
            
            DispatchQueue.main.async {
                
                self.dispImgDummy.isHidden = false
                self.smileLabel.isHidden = false
                self.imageViewObject.removeFromSuperview()
                
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
           
            
        }else if controller.documentPickerMode == .exportToService{
            
            GlobalClass.showAlert(title: Constants.alertTitle, message: "Successfully! Uploaded to iCloud drive", presentVW: self)
        }
        
        
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("Cancelled")
        if controller.documentPickerMode == .import {
       
            GlobalClass.showAlert(title: Constants.alertTitle, message: "If you don't find any files in iCloud, please sync your iCloud or add some files to iCloud from ur iPhone", presentVW: self)

        }else{
            
        }
        
    }
    
    
}

//MARK:- PickerView Delegate Methods
extension iCloudExportImportVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let pickedImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            updateImage(img: pickedImg)
            
            if #available(iOS 11.0, *) {
                if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
                    
                    imageUrl = imageURL
                    
                    print(imageURL)
                }
            } else {
                // Fallback on earlier versions
            }
            
            
        }
        
       
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("picker cancel.")
    }
    
}

// MARK: Functions
extension iCloudExportImportVC {
    
    func importFromiCloud(){
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo), String(kUTTypePlainText), String(kUTTypeMP3)], in: .import)
        
        importMenu.delegate = self
        
        importMenu.modalPresentationStyle = .formSheet
        
        self.present(importMenu, animated: true) {
            
            
        }
    }
    
    
    func exportToiCloud(fileUrl:URL){
        
        let exportMenu = UIDocumentPickerViewController(url: fileUrl, in: .exportToService)
                
        exportMenu.modalPresentationStyle = .formSheet
        
        exportMenu.delegate = self
        
        self.present(exportMenu, animated: true) {
            
        }
    }
    
    @objc func pickImage(_ sender: UITapGestureRecognizer) {
        
       self.openGallary()
    
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
         imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func updateImage(img:UIImage){
        
        DispatchQueue.main.async {
            
            self.imageViewObject = UIImageView(frame:CGRect(x:0, y:0, width:self.takeAPicVW.frame.size.width, height:self.takeAPicVW.frame.size.height))
            
            self.imageViewObject.contentMode = .scaleAspectFill
            self.imageViewObject.clipsToBounds = true
            
            self.dispImgDummy.isHidden = true
            
            self.smileLabel.isHidden = true
            
            self.imageViewObject.image = img
            
            self.takeAPicVW.addSubview(self.imageViewObject)
            
            self.imageViewObject.dropShadow()
            
        }
        
    }
}

// MARK:- UISearchBarDelegates
extension iCloudExportImportVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text?.isEmpty == true {
            searchBar.resignFirstResponder()
        }else{
            searchBar.resignFirstResponder()
        }
        
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text?.isEmpty == true {
            filterSearchArray.removeAll()
            filterSearchArray = importUrlsArray
            self.tableView.reloadData()
            
        }else{
            
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            filterSearchArray.removeAll()
            filterSearchArray = importUrlsArray
            self.tableView.reloadData()
            
            
        }else{
            
            filterSearchArray.removeAll()
            
            let searchTxt = searchText
            
            let queue = DispatchQueue.global(qos: .userInitiated) //QOS_CLASS_USER_INITIATED, 0
            
            queue.async() {
                
                self.filterSearchArray = importUrlsArray.filter({$0.fileName?.lowercased().range(of: searchTxt.lowercased()) != nil})
                
                print(self.filterSearchArray.count)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
            
        }
        
    }
    
    
}
