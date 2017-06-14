
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
        break
    case .denied:
        // beg the user to authorize us in Settings
        break
    }
}


class PhotoPagesVC: UIViewController {
                            
    var pvc: UIPageViewController?
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
        _ = self.determineStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(determineStatus), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func tryToAddInitialPage() {
        self.modelController = ModelController()
        if let dvc = self.modelController.viewController(at: 0, storyboard: self.storyboard!) {
            let viewControllers = [dvc]
            self.pvc!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
            self.pvc!.dataSource = self.modelController
        }
    }
    
    func setUpInterface() {
        self.pvc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pvc!.dataSource = nil
        self.tryToAddInitialPage() // if succeeds, will set data source for real
        
        self.addChildViewController(self.pvc!)
        self.view.addSubview(self.pvc!.view)
        self.pvc!.view.frame = self.view.bounds
        self.pvc!.didMove(toParentViewController: self)
    }
}

extension PhotoPagesVC : PHPhotoLibraryChangeObserver {
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

extension PhotoPagesVC {
    @IBAction func doVignetteButton(_ sender: AnyObject) {
        if !self.determineStatus() {
            print("not authorized")
            return
        }

        if let dvc = self.pvc?.viewControllers?[0] as? DataViewController {
            dvc.doVignette()
        }
    }

}


