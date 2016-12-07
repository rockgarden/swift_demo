//
//  MovieVC.swift
//  PhotoKitImages
//

import UIKit
import Photos
import AVKit

class MoiveVC: UIViewController {
    @IBOutlet weak var v: UIView!

    @IBAction func doShowMovie(_ sender: Any) {
        checkForPhotoLibraryAccess(andThen: self.reallyShowMovie)
    }

    func reallyShowMovie() {
        let opts = PHFetchOptions()
        opts.fetchLimit = 1
        let result = PHAsset.fetchAssets(with: .video, options: opts)
        guard result.count > 0 else {return}
        let asset = result[0]
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: nil) {
            item, info in
            print(item as Any)
            if let item = item {
                DispatchQueue.main.async {
                    self.display(item:item)
                }
            }
        }
    }

    func display(item:AVPlayerItem) {
        let player = AVPlayer(playerItem: item)
        let vc = AVPlayerViewController()
        vc.player = player
        vc.view.frame = self.v.bounds
        self.addChildViewController(vc)
        self.v.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
}


