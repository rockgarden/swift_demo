
import UIKit
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

class RootViewController: UIViewController {
                            
    var pageViewController: UIPageViewController?
    var modelController : ModelController!
    
    /*
    Because authorization is asynchronous, we face an interesting problem:
    if we get the authorization dialog, even if the user accepts,
    our setup code will have returned without succeededing in getting an initial image
    
    So what we'd like to do in that case is try again;
    thus we want to be notified if authorization happens.
    The way to detect that is to observe that we now have images where previously we had none
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        self.setUpInterface()
    }

    func determineStatus() -> Bool {
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.determineStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(determineStatus), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func tryToAddInitialPage() {
        self.modelController = ModelController()
        if let dvc = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!) {
            let viewControllers = [dvc]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
            self.pageViewController!.dataSource = self.modelController
        }
    }
    
    func setUpInterface() {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.dataSource = nil
        self.tryToAddInitialPage() // if succeeds, will set data source for real
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.view.frame = self.view.bounds
        self.pageViewController!.didMove(toParentViewController: self)
    }
}

extension RootViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInfo: PHChange) {
        if let ci = changeInfo.changeDetails(for: self.modelController.recentAlbums as! PHFetchResult<PHObject>) {
            // if what just happened is: we went from nil to results (because user granted permission)...
            // then start over
            let oldResult = ci.fetchResultBeforeChanges
            if oldResult.firstObject == nil {
                let newResult = ci.fetchResultAfterChanges
                if newResult.firstObject != nil {
                    DispatchQueue.main.async {
                        self.tryToAddInitialPage()
                    }
                }
            }
        }
    }
}

extension RootViewController {
    @IBAction func doVignetteButton(_ sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        if let dvc = self.pageViewController?.viewControllers?[0] as? DataViewController {
            dvc.doVignette()
        }
    }

    @available(iOS 9.1, *)
    @IBAction func displayLivePhoto(_ sender: Any) {
        checkForPhotoLibraryAccess {
            let recs = PHAssetCollection.fetchAssetCollections(with:
                .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            guard let rec = recs.firstObject else {return}
            let options = PHFetchOptions()
            let pred = NSPredicate(format: "(mediaSubtype & %d) != 0", PHAssetMediaSubtype.photoLive.rawValue)
            options.predicate = pred
            options.fetchLimit = 1
            let photos = PHAsset.fetchAssets(in: rec, options: options)
            if photos.count > 0 {
                let photo = photos[0]
                let opts = PHLivePhotoRequestOptions()
                opts.deliveryMode = .highQualityFormat
                PHImageManager.default().requestLivePhoto(for: photo, targetSize: CGSize(300,300), contentMode: .aspectFit, options: opts) {
                    photo, info in
                    print(photo?.size as Any)
                    let v = PHLivePhotoView(frame: CGRect(20,20,300,300))
                    v.contentMode = .scaleAspectFit
                    v.livePhoto = photo
                    //TODO: show in Page
                    self.view.addSubview(v)
                }

            }
            
        }
    }

}


