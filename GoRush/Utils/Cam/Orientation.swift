/*Copyright (c) 2016, Andrew Walz.*/

import Foundation
import AVFoundation
import UIKit


class Orientation  {
    
    var shouldUseDeviceOrientation: Bool  = false
    
    fileprivate var deviceOrientation : UIDeviceOrientation?
    
    init() {
    }
    
    func start() {
        self.deviceOrientation = UIDevice.current.orientation
       
    }
  
   
    
    func getImageOrientation(forCamera: SwiftyCamViewController.CameraSelection) -> UIImage.Orientation {
        guard shouldUseDeviceOrientation, let deviceOrientation = self.deviceOrientation else { return forCamera == .rear ? .right : .leftMirrored }
        
        switch deviceOrientation {
        case .landscapeLeft:
            return forCamera == .rear ? .up : .downMirrored
        case .landscapeRight:
            return forCamera == .rear ? .down : .upMirrored
        case .portraitUpsideDown:
            return forCamera == .rear ? .left : .rightMirrored
        default:
            return forCamera == .rear ? .right : .leftMirrored
        }
    }
    
    func getPreviewLayerOrientation() -> AVCaptureVideoOrientation {
        // Depends on layout orientation, not device orientation
        switch UIApplication.shared.statusBarOrientation {
        case .portrait, .unknown:
            return AVCaptureVideoOrientation.portrait
        case .landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        case .portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        @unknown default:
            fatalError()
        }
    }
    
    func getVideoOrientation() -> AVCaptureVideoOrientation? {
        guard shouldUseDeviceOrientation, let deviceOrientation = self.deviceOrientation else { return nil }
        
        switch deviceOrientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
   
}



