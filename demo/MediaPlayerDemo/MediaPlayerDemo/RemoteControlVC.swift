//
//  RemoteControlVC.swift
//  MediaPlayerDemo
//

import UIKit
import AVFoundation
import MediaPlayer

class RemoteControlVC: UIViewController {

    var player = Player()
    var opaques = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        player.delegate = self
        setMPRemoteCommandCenter() //一般用 remoteControlReceived() 就可
    }

    override var canBecomeFirstResponder : Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    /// Ducking test instructions: 先在设备上运行 APP，后用 Music app 播放音乐，然后 点击 once 按钮来体验 ducking

    /// 现在点击 forever 按钮; 我们永远循环 loop forever
    /// 如果您在Info.plist中设置了音频背景模式，那么当APP在后台时，Forever仍播放。

    // FIXME: Ducking can't test
    @IBAction func doButton (_ sender: Any!) {
        let path = Bundle.main.path(forResource:"test", ofType: "aif")!
        if (sender as! UIButton).currentTitle == "Forever" {
            // for remote control to work, our audio session policy
            // must be Playback or SoloAmbient
            // for background audio to work, it must be Playback
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            self.player.forever = true
        } else {
            // example works better if there is some background audio already playing
            let oth = AVAudioSession.sharedInstance().isOtherAudioPlaying
            print("other audio playing: \(oth)")
            // new iOS 8 feature! finer grained than merely whether other audio is playing
            // 一个布尔值，表示另一个应用程序是否播放音频。当具有不可混合音频会话的另一应用程序播放音频时，该值为真。应用程序应该使用此属性作为静音使应用程序功能继发的音频的提示。
            let hint = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
            print("secondary hint: \(hint)")
            if !oth {
                let alert = UIAlertController(title: "Pointless", message: "You won't get the point of the example unless some other audio is already playing!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
                return
            }
            print("ducking")
            let sess = AVAudioSession.sharedInstance()
            try? sess.setActive(false)
            let opts = sess.categoryOptions.union(.duckOthers)
            try? sess.setCategory(sess.category, mode: sess.mode, options: opts)
            try? sess.setActive(true)
            self.player.forever = false
        }
        self.player.playFile(atPath:path)
    }

    // ======== respond to remote controls

    var which = 0 // 0 means use target-action, 1 means use handler
    func setMPRemoteCommandCenter() {
        let scc = MPRemoteCommandCenter.shared()
        switch which {
        case 0:
            scc.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
            scc.playCommand.addTarget(self, action:#selector(doPlay))
            scc.pauseCommand.addTarget(self, action:#selector(doPause))
            scc.likeCommand.addTarget(self, action:#selector(doLike))
            scc.likeCommand.localizedTitle = "Fantastic"
        case 1:
            let p = self.player.avPlayer!
            opaques["playPause"] = scc.togglePlayPauseCommand.addTarget {
                _ in //必须用 [unowned self] 
                if p.isPlaying { p.pause() } else { p.play() }
                return .success
            }
            opaques["play"] = scc.playCommand.addTarget {
                _ in
                p.play()
                return .success
            }
            opaques["pause"] = scc.pauseCommand.addTarget {
                _ in
                p.pause()
                return .success
            }
        default:break
        }
    }

    override func remoteControlReceived(with event: UIEvent?) { // *
        let rc = event!.subtype
        let p = self.player.avPlayer!
        print("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
        switch rc {
        case .remoteControlTogglePlayPause:
            if p.isPlaying { p.pause() } else { p.play() }
        case .remoteControlPlay:
            p.play()
        case .remoteControlPause:
            p.pause()
        default:break
        }

    }

    // these are used only in case 0

    @objc func doPlayPause(_ event:MPRemoteCommandEvent) {
        print("playpause")
        let p = self.player.avPlayer!
        if p.isPlaying { p.pause() } else { p.play() }
    }

    @objc func doPlay(_ event:MPRemoteCommandEvent) {
        print("play")
        let p = self.player.avPlayer!
        p.play()
    }

    @objc func doPause(_ event:MPRemoteCommandEvent) {
        print("pause")
        let p = self.player.avPlayer!
        p.pause()
    }
    
    @objc func doLike(_ event:MPRemoteCommandEvent) {
        print("like")
    }

    // MARK: - must deregister or can crash later!

    deinit {
        print("deinit")
        let scc = MPRemoteCommandCenter.shared()
        switch which {
        case 0:
            scc.togglePlayPauseCommand.removeTarget(self)
            scc.playCommand.removeTarget(self)
            scc.pauseCommand.removeTarget(self)
            scc.likeCommand.removeTarget(self)
        case 1:
            scc.togglePlayPauseCommand.removeTarget(self.opaques["playPause"])
            scc.playCommand.removeTarget(self.opaques["play"])
            scc.pauseCommand.removeTarget(self.opaques["pause"])
        default:break
        }
    }
}


extension RemoteControlVC: PlayerDelegate {
    func soundFinished(_ sender: Any) { // delegate message from Player
        self.unduck()
    }

    func unduck() {
        print("unducking")
        let sess = AVAudioSession.sharedInstance()
        try? sess.setActive(false)
        let opts = sess.categoryOptions.symmetricDifference(.duckOthers)
        try? sess.setCategory(sess.category, mode: sess.mode, options:opts)
        try? sess.setActive(true)
    }
}

