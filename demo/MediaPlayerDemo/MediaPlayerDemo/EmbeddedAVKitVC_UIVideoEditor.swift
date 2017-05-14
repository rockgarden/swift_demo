//
//  EmbeddedAVKitVC_UIVideoEditor.swift
//  MediaPlayerDemo
//

import UIKit
import AVKit
import AVFoundation

class EmbeddedAVKitVC_UIVideoEditor: UIViewController {

    var didInitialLayout = false

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }
        return .landscape
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)

        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.barHideOnTapGestureRecognizer.isEnabled = false
    }

    let which = 2

    override func viewDidLayoutSubviews() {
        if !self.didInitialLayout {
            self.didInitialLayout = true
            switch which {
            case 1:
                self.setUpChildSimple()
            case 2:
                self.setUpChild()
            default:break
            }
        }
    }

    func setUpChildSimple() {
        let url = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
        let player = AVPlayer(url:url)
        let av = AVPlayerViewController()
        av.player = player
        av.view.frame = CGRect(10,74,300,200)
        self.addChildViewController(av)
        self.view.addSubview(av.view)
        av.didMove(toParentViewController:self)
    }

    // is this a bug? We can't use `isReadyForDisplay` here
    // presumably because that is only the getter
    let readyForDisplay = #keyPath(AVPlayerViewController.readyForDisplay)

    func setUpChild() {

        let url = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(url:url)
        let item = AVPlayerItem(asset:asset)
        let player = AVPlayer(playerItem:item)

        let av = AVPlayerViewController()

        av.player = player
        av.view.frame = CGRect(10, 74, 300, 200)
        av.view.isHidden = true // looks nicer if we don't show until ready
        self.addChildViewController(av)
        self.view.addSubview(av.view)
        av.didMove(toParentViewController:self)

        /*
         // just experimenting
         let grs = (av.view.subviews[0] as UIView).gestureRecognizers as [UIGestureRecognizer]
         for gr in grs {
         if gr is UIPinchGestureRecognizer {
         gr.enabled = false
         }
         }
         */

        av.addObserver(self, forKeyPath: readyForDisplay, options: .new, context:nil)

        return; // just proving you can swap out the player
        delay(3) {
            let url = Bundle.main.url(forResource:"wilhelm", withExtension:"aiff")!
            let player = AVPlayer(url:url)
            av.player = player
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == readyForDisplay
            else {return}
        guard let vc = object as? AVPlayerViewController
            else {return}
        guard let ok = change?[.newKey] as? Bool
            else {return}
        guard ok
            else {return}
        vc.removeObserver(
            self,
            forKeyPath:keyPath!)
        DispatchQueue.main.async {
            print("finishing")
            vc.view.isHidden = false // hmm, maybe I should be animating the alpha instead
            // just playing, pay no attention
            let player = vc.player!
            let item = player.currentItem!
            print(CMTimebaseGetRate(item.timebase!))
        }
    }

    /// SimplestAV Demo
    @IBAction func doPresent(_ sender: Any) {
        switch which {
        case 1:
            let av = AVPlayerViewController()
            let url = Bundle.main.url(forResource:"ElMirage", withExtension: "mp4")!
            // let url = Bundle.main.url(forResource:"wilhelm", withExtension: "aiff")!
            let player = AVPlayer(url: url)
            av.player = player
            self.present(av, animated: true) {
                // av.view.backgroundColor = .green
            }
            //            let iv = UIImageView(image:UIImage(named:"smiley")!)
            //            av.contentOverlayView!.addSubview(iv)
            //            let v = iv.superview!
            //            iv.translatesAutoresizingMaskIntoConstraints = false
            //            NSLayoutConstraint.activate([
            //                iv.bottomAnchor.constraint(equalTo:v.bottomAnchor),
            //                iv.topAnchor.constraint(equalTo:v.topAnchor),
            //                iv.leadingAnchor.constraint(equalTo:v.leadingAnchor),
            //                iv.trailingAnchor.constraint(equalTo:v.trailingAnchor),
            //                ])

            /// Set AVPlayerViewControllerDelegate
            av.delegate = self
            av.allowsPictureInPicturePlayback = true
            av.updatesNowPlayingInfoCenter = true // what does this do?
        case 2:
            // hmmm... this works so poorly that I can't really recommend it
            // if edgesForExtendedLayout is not set, we see the position slider just peeping down;
            // if it is, we don't see it at all, and so important functionality is lost
            // moreover, no matter what I do, the resulting interface is very confusing for the user
            // so I'm going to cut discussion of this approach from the book
            let av = AVPlayerViewController()
            av.edgesForExtendedLayout = []
            self.navigationController?.navigationBar.isTranslucent = false
            let url = Bundle.main.url(forResource:"ElMirage", withExtension: "mp4")!
            // let url = Bundle.main.url(forResource:"wilhelm", withExtension: "aiff")!
            let player = AVPlayer(url: url)
            av.player = player
            av.view.backgroundColor = .green
            self.show(av, sender: self)
        default: break
        }
        
    }

}

extension EmbeddedAVKitVC_UIVideoEditor : UIVideoEditorControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    @IBAction func doEditorButton (_ sender: Any!) {
        let path = Bundle.main.path(forResource:"ElMirage", ofType: "mp4")!
        let can = UIVideoEditorController.canEditVideo(atPath:path)
        if !can {
            print("can't edit this video")
            return
        }
        let vc = UIVideoEditorController()
        vc.delegate = self
        vc.videoPath = path
        // must set to popover _manually_ on iPad! exception on presentation if you don't
        // could just set it; works fine as adaptive on iPhone
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.modalPresentationStyle = .popover
        }
        self.present(vc, animated: true)
        print(vc.modalPresentationStyle.rawValue)
        if let pop = vc.popoverPresentationController {
            let v = sender as! UIView
            pop.sourceView = v
            pop.sourceRect = v.bounds
            pop.delegate = self
        }
        // both Cancel and Save on phone (Cancel and Use on pad) dismiss the v.c.
        // but without delegate methods, you don't know what happened or where the edited movie is
        // with delegate methods, on the other hand, dismissing is up to you
    }

    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath path: String) {
        print("saved to \(path)")
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
            print("saving to photos album")
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(savedVideo), nil)
        } else {
            print("can't save to photos album, need to think of something else")
        }
    }

    func savedVideo(at path:String, withError error:Error?, ci:UnsafeMutableRawPointer) {
        print(path)
        if let error = error {
            print("error: \(error)")
        } else {
            print("success!")
        }
        /*
         Important to check for error, because user can deny access
         to Photos library
         If that's the case, we will get error like this:
         Error Domain=ALAssetsLibraryErrorDomain Code=-3310 "Data unavailable" UserInfo=0x1d8355d0 {NSLocalizedRecoverySuggestion=Launch the Photos application, NSUnderlyingError=0x1d83d470 "Data unavailable", NSLocalizedDescription=Data unavailable}
         */
        self.dismiss(animated:true)
    }

    func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
        print("editor cancelled")
        self.dismiss(animated:true)
    }

    func videoEditorController(_ editor: UIVideoEditorController, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
        self.dismiss(animated:true)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let vc = viewController as UIViewController
        vc.title = ""
        vc.navigationItem.title = ""
        // I can suppress the title but I haven't found a way to fix the right bar button
        // (so that it says Save instead of Use)
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("editor popover dismissed")
    }

}

extension EmbeddedAVKitVC_UIVideoEditor : AVPlayerViewControllerDelegate {

    //    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
    //        return false
    //    }

    func playerViewController(_ pvc: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler ch: @escaping (Bool) -> Void) {
        self.present(pvc, animated:true) {
            ch(true)
        }
    }
    
}

