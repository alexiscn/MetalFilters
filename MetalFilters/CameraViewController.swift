//
//  CameraViewController.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/6.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    fileprivate let sessionQueue = DispatchQueue(label: "me.shuifeng.session.queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem, target: nil)
    
    fileprivate let processingQueue = DispatchQueue(label: "me.shuifeng.processing.queue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem, target: nil)
    
    fileprivate let session = AVCaptureSession()
    fileprivate var isSessionRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func checkPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { granted in
                
            }
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let pixelBuffer = photo.pixelBuffer else {
            return
        }
        var photoFormatDescription: CMFormatDescription?
        
        
    }
    
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
}
