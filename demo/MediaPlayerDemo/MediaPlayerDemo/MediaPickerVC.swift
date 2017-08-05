//
//  MediaPickerVC.swift
//  MediaPlayerDemo
//

import UIKit
import MediaPlayer


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
