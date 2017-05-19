//
//  PlayerLayerVC.swift
//  MediaPlayerDemo
//

import UIKit
import AVFoundation
import AVKit

/// Test for AVPlayerLayer
class PlayerLayerVC: UIViewController {

    var player : AVPlayer!
    var playerLayer : AVPlayerLayer! //AVPlayerLayer是CALayer的子类，AVPlayer对象可以指向其视觉输出。它可以用作UIView或NSView的背衬层，或者可以手动添加到图层层次结构中，以在屏幕上显示您的视频内容。
    var pip : AVPictureInPictureController!
    @IBOutlet weak var picButton: UIButton!

    let which = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        let m = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(url:m)
        let item = AVPlayerItem(asset:asset)

        switch which {
        case 1:
            let p = AVPlayer(playerItem:item)
            self.player = p //might need a reference later
            let lay = AVPlayerLayer(player:p)
            lay.frame = CGRect(10,84,300,200)
            self.playerLayer = lay //might need a reference later
        case 2:
            let p = AVPlayer()
            self.player = p
            let lay = AVPlayerLayer(player:p)
            lay.frame = CGRect(10,84,300,200)
            self.playerLayer = lay
            p.replaceCurrentItem(with: item)
        default:
            break
        }

        /// 画中画PiP iPhone 不支持
        if AVPictureInPictureController.isPictureInPictureSupported() {
            let pic = AVPictureInPictureController(playerLayer: self.playerLayer)
            self.pip = pic
        } else {
            self.picButton.isHidden = true
        }

        self.playerLayer.addObserver(self, forKeyPath:#keyPath(AVPlayerLayer.readyForDisplay), context:nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerLayer.readyForDisplay) {
            DispatchQueue.main.async {
                self.finishConstructingInterface()
            }
        }
    }

    private func finishConstructingInterface () {
        if (!self.playerLayer.isReadyForDisplay) {
            return
        }

        self.playerLayer.removeObserver(self, forKeyPath:#keyPath(AVPlayerLayer.readyForDisplay))

        if self.playerLayer.superlayer == nil {
            view.layer.addSublayer(self.playerLayer)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    @IBAction func doButton (_ sender: Any!) {
        let rate = self.player.rate
        self.player.rate = rate < 0.01 ? 1 : 0
    }

    @IBAction func restart (_ sender: Any!) {
        let item = self.player.currentItem!
        item.seek(to:CMTime(seconds:0, preferredTimescale:600))
    }

    @IBAction func doPicInPic(_ sender: Any) {
        if self.pip.isPictureInPicturePossible {
            self.pip.startPictureInPicture()
        }
    }

}


extension PlayerLayerVC: AVPictureInPictureControllerDelegate {

    /// 当画中画即将停止时，调用它，让您的应用有机会恢复其视频播放用户界面。当PiP结束时，实现此方法重新建立视频播放用户界面。无论PiP如何结束，无论是用户是否结束播放，用户都可以轻按按钮，将视频回放到您的应用程序，或视频完成播放。
    func picture(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @ escaping (Bool) -> Void) {
    }
}
