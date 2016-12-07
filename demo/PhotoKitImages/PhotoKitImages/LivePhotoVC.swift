//
//  LivePhotoVC.swift
//  PhotoKitImages
//

import UIKit
import Photos
import PhotosUI // NB!

class LivePhotoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

