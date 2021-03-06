//
//  ViewController.swift
//  AVFoundationDemo
//
//  Created by wangkan on 2017/8/5.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class AVFoundationVC: UIViewController {

    var sess : AVCaptureSession!
    var snapper : AVCaptureStillImageOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var iv : UIImageView!
    var previewImage : UIImage!
    let previewRect = CGRect(x: 10,y: 30,width: 300,height: 300)


    @IBAction func doStart (_ sender: Any!) {
        checkForMovieCaptureAccess(andThen:self.micCheck)
    }

    func micCheck() {
        checkForMicrophoneCaptureAccess(andThen:self.reallyStart)
    }

    func reallyStart() {
        if self.sess != nil && self.sess.isRunning {
            self.sess.stopRunning()
            self.previewLayer.removeFromSuperlayer()
            self.sess = nil
            return
        }

        self.sess = AVCaptureSession()

        do {
            self.sess.beginConfiguration()

            /// Old code just: self.sess.sessionPreset = AVCaptureSessionPreset640x480
            let preset = AVCaptureSessionPresetPhoto
            guard self.sess.canSetSessionPreset(self.sess.sessionPreset) else {return}
            self.sess.sessionPreset = preset

            if #available(iOS 10.0, *) {
                let output = AVCapturePhotoOutput()
                guard self.sess.canAddOutput(output) else {return}
                self.sess.addOutput(output)
            } else {
                self.snapper = AVCaptureStillImageOutput()
                self.snapper.outputSettings = [
                    AVVideoCodecKey: AVVideoCodecJPEG,
                    AVVideoQualityKey: 0.6
                ]
                self.sess.addOutput(self.snapper)
            }
            self.sess.commitConfiguration()
        }

        let cam = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        guard let input = try? AVCaptureDeviceInput(device:cam) else {return}
        self.sess.addInput(input)

        let lay = AVCaptureVideoPreviewLayer(session:self.sess)
        lay?.frame = self.previewRect
        self.view.layer.addSublayer(lay!)
        self.previewLayer = lay // keep a ref so we can remove it later

        self.sess.startRunning()
    }

    @IBAction func doSnap (_ sender: Any!) {
        guard self.sess != nil && self.sess.isRunning else {return}

        if #available(iOS 10.0, *) {
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .auto
            settings.isAutoStillImageStabilizationEnabled = true
            // let's also ask for a preview image
            let pbpf = settings.availablePreviewPhotoPixelFormatTypes[0]
            let len = max(self.previewLayer.bounds.width, self.previewLayer.bounds.height)
            settings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey as String : pbpf,
                kCVPixelBufferWidthKey as String : len,
                kCVPixelBufferHeightKey as String : len
            ]

            guard let output = self.sess.outputs[0] as? AVCapturePhotoOutput else {return}

            if let conn = output.connection(withMediaType: AVMediaTypeVideo) {
                let orientation = UIDevice.current.orientation.videoOrientation!
                conn.videoOrientation = orientation
            }
            output.capturePhoto(with: settings, delegate: self)
        } else {
            let vc = self.snapper.connection(withMediaType: AVMediaTypeVideo)
            self.snapper.captureStillImageAsynchronously(from: vc) {
                (buf, err) in
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buf)
                let im = UIImage(data:data!)
                DispatchQueue.main.async {

                    self.previewLayer.removeFromSuperlayer()
                    self.sess.stopRunning()
                    self.sess = nil

                    let iv = UIImageView(frame:self.previewLayer.frame)
                    iv.contentMode = .scaleAspectFit
                    iv.image = im
                    self.view.addSubview(iv)
                    self.iv?.removeFromSuperview()
                    self.iv = iv
                }
            }
        }
    }
}

@available(iOS 10.0, *)
extension AVFoundationVC : AVCapturePhotoCaptureDelegate {

    func capture(_ output: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer sampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        print("photo", resolvedSettings.photoDimensions)
        print("preview", resolvedSettings.previewDimensions)
        print("flash", resolvedSettings.isFlashEnabled)
        //let width = resolvedSettings.photoDimensions.width
        //let height = resolvedSettings.photoDimensions.height
        //let landscape = width > height
        if let prev = previewPhotoSampleBuffer {
            print("got preview image")
            if let buff = CMSampleBufferGetImageBuffer(prev) {
                print("got image buffer")
                let cim = CIImage(cvPixelBuffer: buff)
                self.previewImage = UIImage(ciImage: cim)
            }
        }
        if let buff = sampleBuffer {
            if let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buff, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {

                checkForPhotoLibraryAccess {
                    print("saving to library")
                    let lib = PHPhotoLibrary.shared()
                    lib.performChanges({
                        let req = PHAssetCreationRequest.forAsset()
                        req.addResource(with: .photo, data: data, options: nil)
                    })
                }
            }
        }
    }

    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {

        DispatchQueue.main.async {
            self.previewLayer.removeFromSuperlayer()
            self.sess.stopRunning()
            self.sess = nil

            if let im = self.previewImage {
                let iv = UIImageView(frame:self.previewLayer.frame)
                iv.contentMode = .scaleAspectFit
                iv.image = im
                self.view.addSubview(iv)
                self.iv?.removeFromSuperview()
                self.iv = iv
            }
        }
    }

}

