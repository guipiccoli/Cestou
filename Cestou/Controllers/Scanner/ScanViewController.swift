//
//  ViewController.swift
//  Cestou
//
//  Created by Guilherme Piccoli on 26/04/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let qrCodeController = segue.destination as? DetailsViewController {
            if let QRlabel = sender as? String {
                qrCodeController.stringQrCode = QRlabel
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DetailsViewController.didConfirm{
            self.tabBarController?.selectedIndex = 2
        }
    }
    
    override func viewDidLoad() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
            print("Failed to access the camera")
            return
        }
        
        do {
            //get an instance of the AVCaptureDeviceInput class using the device above
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input) //Setting the input device on the current capture session
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) //when a new metadataObject is captured we forward it to the delegate method
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr] //specifying that the metadata must be a qr code
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill //makes the video resize to fill the screen
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!) //adds the camera preview to the current view
            
            //Start video capture
            captureSession.startRunning()
            
            //Move the message label and top bar to the front
            
            //initializing the green box
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
        
        super.viewDidLoad()
    }
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //checks if the metadata is not nill
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
        }
            
            //get the metadata object
        else {
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject //decodes the information to a readable type
            
            if metadataObj.type == AVMetadataObject.ObjectType.qr { //checks if the metadata is a qr code
                //gets the size of the qr code and sets the frame of the qrCodeFrameView (the green box) to the same size
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
                
                if metadataObj.stringValue != nil {
                    captureSession.stopRunning()
                    performSegue(withIdentifier: "QRCodeRead", sender: String(metadataObj.stringValue!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) )
                }
            }
        }
    }
}

