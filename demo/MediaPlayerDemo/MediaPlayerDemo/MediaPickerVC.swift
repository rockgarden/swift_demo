//
//  MediaPickerVC.swift
//  MediaPlayerDemo
//

import UIKit
import MediaPlayer

func checkForMusicLibraryAccess(andThen f:(()->())? = nil) {
    let status = MPMediaLibrary.authorizationStatus()
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        MPMediaLibrary.requestAuthorization() { status in
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

class MediaPickerVC: UIViewController {

    @IBAction func doGo (_ sender: Any!) {
        self.presentPicker(sender)
    }

    func presentPicker (_ sender: Any) {
        checkForMusicLibraryAccess {
            let picker = MPMediaPickerController(mediaTypes:.music)
            picker.showsCloudItems = false
            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            picker.modalPresentationStyle = .popover
            picker.preferredContentSize = CGSize(500,600)
            self.present(picker, animated: true)
            if let pop = picker.popoverPresentationController {
                if let b = sender as? UIBarButtonItem {
                    pop.barButtonItem = b
                }
            }
        }
    }
}

extension MediaPickerVC : MPMediaPickerControllerDelegate {
    // must implement these, as there is no automatic dismissal

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("did pick")
        let player = MPMusicPlayerController.applicationMusicPlayer()
        player.setQueue(with:mediaItemCollection)
        player.play()
        self.dismiss(animated:true)
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.dismiss(animated:true)
    }

}

extension MediaPickerVC : UIBarPositioningDelegate {
    func positionForBar(forBar bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
