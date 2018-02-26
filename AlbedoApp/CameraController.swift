//
//  CameraController.swift
//  AlbedoApp
//
//  Created by crt2004 on 12/22/17.
//
//  Adapted from:
//
//  "Building a Full Screen Camera App Using AVFoundation" by Pranjal Satija, AppCoda.com
//  https://www.appcoda.com/avfoundation-swift-guide/
//
//  Apple's Photo Capture Guide
//  https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/PhotoCaptureGuide/index.html
//

import AVFoundation
import UIKit

/*@objc protocol AVCapturePhotoOutputType {
   @objc(availableRawPhotoPixelFormatTypes)
    var __availableRawPhotoPixelFormatTypes: [NSNumber] {get}
}*/

class CameraController: NSObject {
    var captureSession: AVCaptureSession?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureFlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?
    var rawSampleBuffer: CMSampleBuffer?
    var rawPreviewPhotoSampleBuffer: CMSampleBuffer?
    
    var dngPhotoData: Data? // this is where the raw image data gets stored
}

extension CameraController {
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            guard let rearCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) else {
                print("Error - could not get rear camera device")
                return
            }
            self.rearCamera = rearCamera
            print("Success: got rear camera")
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            guard let rearCameraInput = try? AVCaptureDeviceInput(device: rearCamera) else {
                print("Error - could not create video input for rear camera")
                return
            }
            
            if captureSession.canAddInput(rearCameraInput) { // add the camera input to the session
                captureSession.addInput(rearCameraInput)
                print("Success: added input to capture session: \(rearCameraInput)")
            }
            self.rearCameraInput = rearCameraInput
            self.captureSession = captureSession
        }
        
        func configurePhotoOutput() throws {
            print("Entered configuredPhotoOutput")
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            captureSession.beginConfiguration()
            let photoOutput = AVCapturePhotoOutput()
            //photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
                self.photoOutput = photoOutput
                print("PHOTO OUTPUT 2nd print - we expect an option")
                print(photoOutput.availableRawPhotoPixelFormatTypes)
            }

            captureSession.commitConfiguration()
            captureSession.startRunning()
            self.photoOutput = photoOutput
            self.captureSession = captureSession //
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    // displays the camera view on the UI storyboard
    func displayPreview(on view: UIView) throws {
        //guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }

    // resposnible for capturing the image
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        //guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        /*// specifies that the image must be raw
        guard let availableRawFormat = self.photoOutput?.availableRawPhotoPixelFormatTypes.first else { print("*** There are literally no raw formats available"); return }
        let settings = AVCapturePhotoSettings(rawPixelFormatType: availableRawFormat.uint32Value)
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
        */
        
        /*// this is the only type supported in modern iPhones besides kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange and kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        let photoSettings =  try AVCapturePhotoSettings(format: [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA)])
        
        guard (photoOutput?.availableRawPhotoPixelFormatTypes.contains(NSNumber(value: rawFormatType)))! else { print("*** Raw Format Type Unavailable"); return }
        
        
        photoOutput?.capturePhoto(with: photoSettings, delegate: self)
        self.photoCaptureCompletionBlock = completion
        */
        
        //print("Here it is:")
        //print("-----------")
        //print(photoOutput?.__availableRawPhotoPixelFormatTypes)
        
        /*let rawFormatType = kCVPixelFormatType_32BGRA
        guard (photoOutput?.availableRawPhotoPixelFormatTypes.contains(NSNumber(value: rawFormatType)))! else {
            print("*** ERROR: No available raw pixel formats ***")
            return
        }*/
        
        //let pixelFormatType = NSNumber(value: kCVPixelFormatType_32BGRA)
        //guard (photoOutput?.availableRawPhotoPixelFormatTypes.contains(pixelFormatType))! else { print("ERROR: No available raw pixel formats"); return }
        
        guard let photoOutput = self.photoOutput else { // prevents need for optional unwrapping
            return
        }
        
        print(photoOutput.availableRawPhotoPixelFormatTypes)

        guard let availableRawFormat = photoOutput.availableRawPhotoPixelFormatTypes.first else { print("*** There are literally no raw formats available"); return }
        let settings = AVCapturePhotoSettings(rawPixelFormatType: availableRawFormat.uint32Value)
        
        /*let settings = AVCapturePhotoSettings(format: [
            kCVPixelBufferPixelFormatTypeKey as String : pixelFormatType
            ])*/

        photoOutput.capturePhoto(with: settings, delegate: self)
        print("Capture Photo Occurred!")
    }
}

extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    
    public func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingRawPhotoSampleBuffer rawSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        /*if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = rawSampleBuffer, let data = AVCapturePhotoOutput.dngPhotoDataRepresentation(forRawSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            
            self.photoCaptureCompletionBlock?(image, nil)
            print("something happens here")
        }
            
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
        print("did finish processing!!!!!!!!!!!")
        guard error == nil, let rawSampleBuffer = rawSampleBuffer else {
            print("Error capturing RAW photo:\(String(describing: error))")
            return
        }
        
        self.rawSampleBuffer = rawSampleBuffer
        self.rawPreviewPhotoSampleBuffer = previewPhotoSampleBuffer*/
        
        if let error = error {
            print("Error - RAW image could not be captured: \(error)")
        }
        self.dngPhotoData = AVCapturePhotoOutput.dngPhotoDataRepresentation(forRawSampleBuffer: rawSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        
        /*
        // convert the NSData object to a CGImage so that the individual pixels can be analyzed
        //let myDataRef:CFData = self.dngPhotoData as! CFData
        //let imageSource:CGImageSource = CGImageSourceCreateWithData(myDataRef, nil)!
        //let rawCGImage:CGImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)!
        
        // convert the NSData object to a UIImage so that the individual pixels can be analyzed
        let rawUIImage:UIImage = UIImage(data:dngPhotoData!, scale:1.0)!
        
        // check to be sure the conversion worked before using
        if rawUIImage == .none {
            print("Error - image could not be converted")
        }
        calculate(image:rawUIImage)
         */
    }
    
    /*func calculate(image:UIImage) {
        var sumR:UInt8 = 0, sumG:UInt8 = 0, sumB:UInt8 = 0
        if let reader = ImagePixelReader(image: image) {
            // iterate over all pixels
            for x in 0 ..< Int(image.size.width){
                for y in 0 ..< Int(image.size.height){
                    let color = reader.colorAt(x: x, y: y)
                    sumR += color.r
                    sumG += color.g
                    sumB += color.b
                }
            }
        }
    }*/
}
