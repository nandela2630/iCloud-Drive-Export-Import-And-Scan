//
//  ScanViewController.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/25/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import UIKit
import AVFoundation
class ScanViewController: UIViewController {

    @IBOutlet weak var startAndStopBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    // Declarations
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    let captureMetadataOutput = AVCaptureMetadataOutput()
    var topTitle:String?
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.dataMatrix,AVMetadataObject.ObjectType.code93,AVMetadataObject.ObjectType.interleaved2of5,AVMetadataObject.ObjectType.itf14]
    
    
    //MARK:Views
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Scan QR/Barcodes"
        
        self.messageLabel.text = "Scan any Barcode/QR Code to see the result"
        
        GlobalClass.checkCameraStatus { (sucess) in
            
            if sucess {
                
                self.initialize()
                
            }else{
                
                DispatchQueue.main.async {
                    GlobalClass.showAlert(title: Constants.allowCameraTitle, message: "\(Constants.allowCamerForQRScan)\(Constants.allowCameraInstructs)", presentVW: self)
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: Initializers
    func initialize(){
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            //Sanju
            //try to enable auto focus
            if(captureDevice!.isFocusModeSupported(.continuousAutoFocus)) {
                try! captureDevice!.lockForConfiguration()
                captureDevice!.focusMode = .continuousAutoFocus
                captureDevice!.unlockForConfiguration()
            }
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            
            if (captureSession?.isRunning == true) {
                captureSession?.stopRunning();
            }
            
            let que = DispatchQueue(label: "QRCodeQue")
            
            que.async {
                
                // Start video capture.
                self.captureSession?.startRunning()
                
                
                DispatchQueue.main.async {
                    
                    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                    self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                    self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.videoPreviewLayer?.frame = self.view.layer.bounds
                    self.view.layer.addSublayer(self.videoPreviewLayer!)
                    
                    
                    // Move the message label to front
                    self.view.bringSubview(toFront: self.messageLabel)
                    self.view.bringSubview(toFront: self.startAndStopBtn)
                   
                    
                    // Initialize QR Code Frame to highlight the QR code
                    self.qrCodeFrameView = UIView()
                    
                    if let qrCodeFrameView = self.qrCodeFrameView {
                        self.qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
                        self.qrCodeFrameView?.layer.borderWidth = 2
                        self.view.addSubview(qrCodeFrameView)
                        self.view.bringSubview(toFront: qrCodeFrameView)
                    }
                    
                    
                }
                
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }
    
    
    //MARK:UIButton Actions
    //Start And Stop
    @IBAction func startAndStopAction(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Stop Scan" {
            
            DispatchQueue.main.async {
               sender.titleLabel?.text = "Start"
                self.messageLabel.text = "Start scanning to see the result"
            }
            
            self.captureSession?.stopRunning()
            
        }else{
            
            DispatchQueue.main.async {
                sender.titleLabel?.text = "Stop Scan"
                self.messageLabel.text = "Start scanning to see the result"
            }
            
            self.captureSession?.startRunning()
            
            
        }
    }
    
    //MARK: DE INIT
    deinit {
        captureSession = nil
        videoPreviewLayer = nil
        qrCodeFrameView = nil
    }
    

}

// MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
extension ScanViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "Failed / No QR/barcode is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                
                DispatchQueue.main.async {
                    self.messageLabel.text = metadataObj.stringValue
                }
                print(metadataObj.stringValue ?? "null")
                
               // self.delegate?.qrFound(qrStr: metadataObj.stringValue!)
                                
            }
        }
    }
    
    
    
}
