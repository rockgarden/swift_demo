//
//  EmbeddedAVKitVC.swift
//  MediaPlayerDemo
//

import UIKit
import AVKit
import AVFoundation

class EmbeddedAVKitVC: UIViewController {

    let url = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }
        return .landscape
    }

    let which = 2

    // FIXME: AVPlayer 可多次创建
    @IBAction func go() {
        switch which {
        case 1:
            let asset = AVURLAsset(url:url)
            let item = AVPlayerItem(asset:asset)
            let player = AVPlayer(playerItem:item)
            let av = AVPlayerViewController()
            av.view.frame = CGRect(10,74,300,200)
            av.player = player
            self.addChildViewController(av)
            self.view.addSubview(av.view)
            av.didMove(toParentViewController: self)
        case 2:
            setUpChild()
        default: break
        }
    }

    private func setUpChild() {
        let asset = AVURLAsset(url:url)
        let track = #keyPath(AVURLAsset.tracks)
        asset.loadValuesAsynchronously(forKeys:[track]) {
            let status = asset.statusOfValue(forKey:track, error: nil)
            if status == .loaded {
                DispatchQueue.main.async {
                    self.getVideoTrack(asset)
                }
            }
        }
    }

    private func getVideoTrack(_ asset:AVAsset) {
        // we have tracks or we wouldn't be here
        let visual = AVMediaCharacteristic.visual
        let vtrack = asset.tracks(withMediaCharacteristic: visual)[0]
        let size = #keyPath(AVAssetTrack.naturalSize)
        vtrack.loadValuesAsynchronously(forKeys: [size]) {
            let status = vtrack.statusOfValue(forKey: size, error: nil)
            if status == .loaded {
                DispatchQueue.main.async {
                    self.getNaturalSize(vtrack, asset)
                }
            }
        }
    }

    private func getNaturalSize(_ vtrack:AVAssetTrack, _ asset:AVAsset) {
        // we have a natural size or we wouldn't be here
        let sz = vtrack.naturalSize
        let item = AVPlayerItem(asset:asset)
        let player = AVPlayer(playerItem:item)
        let av = AVPlayerViewController()
        av.view.frame = AVMakeRect(aspectRatio: sz, insideRect: CGRect(10,10,300,200))
        av.player = player
        self.addChildViewController(av)
        av.view.isHidden = true
        self.view.addSubview(av.view)
        av.didMove(toParentViewController: self)
        av.addObserver(
            self, forKeyPath: #keyPath(AVPlayerViewController.readyForDisplay), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let ready = #keyPath(AVPlayerViewController.readyForDisplay)
        guard keyPath == ready else {return}
        guard let vc = object as? AVPlayerViewController else {return}
        guard let ok = change?[.newKey] as? Bool else {return}
        guard ok else {return}
        vc.removeObserver(self, forKeyPath:ready)
        DispatchQueue.main.async {
            vc.view.isHidden = false
        }
    }
    
}
