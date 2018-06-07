//
//  MTCameraCaptureSession.swift
//  MTCameraKit
//
//  Created by xu.shuifeng on 2018/6/5.
//

import Foundation
import AVFoundation

public protocol MTCameraCaptureSessionDelegate: class {
    
}

public class MTCameraCaptureSession: NSObject {
    
    fileprivate let photoOutput = AVCapturePhotoOutput()
    fileprivate let internalSession = AVCaptureSession()
    
    public func stopSession() {
        
    }
    
    public func startSession() {
        
    }
}

extension MTCameraCaptureSession: AVCapturePhotoCaptureDelegate {
    
}
