
import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import Photos
import PhotosUI

func checkForPhotoLibraryAccess(andThen f:(()->())? = nil) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization() { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        break
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var redView: UIView!
    weak var picker : UIImagePickerController?
    var pushMyPhotoView = false //是否使用自定义的PhotoView

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if self.traitCollection.userInterfaceIdiom == .pad {
            return .all
        }
        return .all
    }

    func determineStatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
            return false
        case .restricted:
            return false
        case .denied:
            let alert = UIAlertController(
                title: "Need Authorization",
                message: "Wouldn't you like to authorize this app " +
                "to use the camera?",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "OK", style: .default, handler: {
                    _ in
                    let url = URL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.shared.openURL(url)
            }))
            self.present(alert, animated:true, completion:nil)
            return false
        }
    }

    func determineStatusPHPhotoLibrary() -> Bool {
        // access permission dialog will appear automatically if necessary...
        // ...when we try to present the UIImagePickerController
        // however, things then proceed asynchronously
        // so it can look better to try to ascertain permission in advance
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() {_ in}
            return false
        case .restricted:
            return false
        case .denied:
            // new iOS 8 feature: sane way of getting the user directly to the relevant prefs
            // I think the crash-in-background issue is now gone
            let alert = UIAlertController(title: "Need Authorization", message: "Wouldn't you like to authorize this app to use your Photos library?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                _ in
                let url = URL(string:UIApplicationOpenSettingsURLString)!
                UIApplication.shared.openURL(url)
            }))
            self.present(alert, animated:true, completion:nil)
            return false
        }
    }

    /*
     New authorization strategy: check for authorization when we first appear, when we are brought back to the front, and when the user taps a button whose functionality needs authorization.
     */

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(determineStatus),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func doPick (_ sender: AnyObject!) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }
        checkForPhotoLibraryAccess {
            self.pickPhoto(sender)
        }

    }

    fileprivate func pickPhoto(_ sender: AnyObject!) {
        // horrible SavedPhotosAlbum 极不友好的api
        // let src = UIImagePickerControllerSourceType.SavedPhotosAlbum

        let src = UIImagePickerControllerSourceType.photoLibrary
        guard UIImagePickerController.isSourceTypeAvailable(src)
            else { debugPrint("alas"); return }
        guard let arr = UIImagePickerController.availableMediaTypes(for: src)
            else { print("no available types"); return }

        let picker = MyImagePickerController() // see comments below for reason
        picker.sourceType = src
        picker.mediaTypes = arr //[kUTTypeLivePhoto as String, kUTTypeImage as String, kUTTypeMovie as String]
        picker.delegate = self
        picker.allowsEditing = false // try true

        // this will automatically be fullscreen on phone and pad, looks fine
        // note that for .PhotoLibrary, iPhone app must permit portrait orientation
        // if we want a popover, on pad, we can do that; just uncomment next line
        picker.modalPresentationStyle = .popover
        self.present(picker, animated: true, completion: nil)
        // ignore:
        if let pop = picker.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
        }
    }

    @IBAction func doTake (_ sender:AnyObject!) {
        let cam = UIImagePickerControllerSourceType.camera
        let ok = UIImagePickerController.isSourceTypeAvailable(cam)
        if (!ok) {
            print("no camera")
            return
        }
        let desiredType = kUTTypeImage as String
        // let desiredType = kUTTypeMovie as NSString as String
        let arr = UIImagePickerController.availableMediaTypes(for: cam)
        print(arr!)
        if arr?.index(of: desiredType) == nil {
            print("no capture")
            return
        }
        let picker = MyImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [desiredType]
        picker.allowsEditing = true
        picker.delegate = self

        //FIXME: cameraOverlayView addGestureRecognizer 无效
        //        picker.showsCameraControls = false
        //        let f = self.view.window!.bounds
        //        let v = UIView(frame:f)
        //        debugPrint(v)
        //        let t = UITapGestureRecognizer(target:self, action:#selector(tap))
        //        t.numberOfTapsRequired = 2
        //        v.addGestureRecognizer(t)
        //        picker.cameraOverlayView = v

        self.picker = picker

        // user will get the "access the camera" system dialog at this point if necessary
        // if the user refuses, Very Weird Things happen...
        // better to get authorization beforehand
        self.present(picker, animated: true, completion: nil)
    }

    func tap(_ g: UIGestureRecognizer) {
        self.picker?.takePicture()
    }

    func doCancel(_ sender:AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    func doUse(_ im:UIImage?) {
        if im != nil {
            showImage(im!)
        }
        self.dismiss(animated: true, completion: nil)
    }

}

// if we do nothing about cancel, cancels automatically
// if we do nothing about what was chosen, cancel automatically but of course now we have no access

// interesting problem is that we have no control over permitted orientations of picker
// seems like a bug; can work around this by subclassing

extension ViewController : UIImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info[UIImagePickerControllerReferenceURL] as Any) //UIImagePickerControllerReferenceURL maybe nil
        let url = info[UIImagePickerControllerMediaURL] as? URL //iOS 10 url = nil
        var im = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let ed = info[UIImagePickerControllerEditedImage] as? UIImage {
            im = ed
        }

        if pushMyPhotoView {
            // push photo view
            let svc = SecondViewController(image:im)
            picker.pushViewController(svc, animated: true)
        } else {
            // no push photo view, than back to ViewController
            self.dismiss(animated: true) {
                let type = info[UIImagePickerControllerMediaType] as? NSString
                if type != nil {
                    switch type! {
                    case kUTTypeMovie: //CFString "public.movie"
                        if url != nil { self.showMovie(url!) }
                    case kUTTypeImage: //CFString "public.image"
                        if im != nil {
                            self.showImage(im!)
                            // showing how simple it is to save into the Camera Roll
                            let lib = PHPhotoLibrary.shared()
                            lib.performChanges({
                                PHAssetChangeRequest.creationRequestForAsset(from: im!)
                            }, completionHandler: nil)
                        }
                    default: break
                    }
                    if #available(iOS 9.1, *) {
                        let live = info[UIImagePickerControllerLivePhoto] as? PHLivePhoto
                        if type! == kUTTypeLivePhoto, live != nil { //,相当于&&?
                            self.showLivePhoto(live!)
                        }
                    }
                }
            }
        }

    }

    fileprivate func clearAll() {
        if self.childViewControllers.count > 0 {
            let av = self.childViewControllers[0] as! AVPlayerViewController
            av.willMove(toParentViewController: nil)
            av.view.removeFromSuperview()
            av.removeFromParentViewController()
        }
        self.redView.subviews.forEach { $0.removeFromSuperview() }
    }

    fileprivate func showImage(_ im:UIImage) {
        self.clearAll()
        let iv = UIImageView(image:im)
        iv.contentMode = .scaleAspectFit
        iv.frame = self.redView.bounds
        self.redView.addSubview(iv)
    }

    ///FIXME: don't run in iOS 10
    fileprivate func showMovie(_ url: URL) {
        self.clearAll()
        let av = AVPlayerViewController()
        let player = AVPlayer(url: url)
        av.player = player
        self.addChildViewController(av)
        av.view.frame = self.redView.bounds
        debugPrint(self.redView.bounds)
        av.view.backgroundColor = self.redView.backgroundColor
        self.redView.addSubview(av.view)
        av.didMove(toParentViewController: self)
    }

    @available(iOS 9.1, *)
    fileprivate func showLivePhoto(_ ph:PHLivePhoto) {
        self.clearAll()
        let v = PHLivePhotoView(frame: self.redView.bounds)
        v.contentMode = .scaleAspectFit
        v.livePhoto = ph
        self.redView.addSubview(v)
    }

}

extension ViewController : UINavigationControllerDelegate {

    // this has no effect
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .landscape
    }

    func navigationController(_ nc: UINavigationController, didShow vc: UIViewController, animated: Bool) {
        if pushMyPhotoView {
            if vc is SecondViewController {
                nc.isToolbarHidden = true
                return
            }
            nc.isToolbarHidden = false

            let sz = CGSize(width: 10,height: 10)
            let im = imageOfSize(sz) {
                UIColor.black.withAlphaComponent(0.1).setFill()
                UIGraphicsGetCurrentContext()!.fill(CGRect(origin: CGPoint(), size: sz))
            }
            nc.toolbar.setBackgroundImage(im, forToolbarPosition: .any, barMetrics: .default)
            nc.toolbar.isTranslucent = true
            let b = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doCancel))
            let lab = UILabel()
            lab.text = "Double tap to take a picture"
            lab.textColor = UIColor.white
            lab.backgroundColor = UIColor.clear
            lab.sizeToFit()
            let b2 = UIBarButtonItem(customView: lab)
            nc.topViewController!.toolbarItems = [b,b2]
            nc.topViewController!.title = "Retake"
        }
    }

}

