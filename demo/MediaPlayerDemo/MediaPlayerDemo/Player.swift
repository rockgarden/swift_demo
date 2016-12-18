

import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerDelegate : class {
    func soundFinished(_ sender: Any)
}

class Player : NSObject, AVAudioPlayerDelegate {
    var player : AVAudioPlayer!
    var forever = false
    weak var delegate : PlayerDelegate?
    var observer : NSObjectProtocol! //addObserver

    override init() {
        super.init()
        // interruption notification
        // note (irrelevant for bk 2, but useful for bk 1) how to prevent retain cycle
        self.observer = NotificationCenter.default.addObserver(forName:
        .AVAudioSessionInterruption, object: nil, queue: nil) {
            [weak self] n in
            let why = n.userInfo![AVAudioSessionInterruptionTypeKey] as! UInt
            let type = AVAudioSessionInterruptionType(rawValue: why)!
            if type == .began {
                print("interruption began:\n\(n.userInfo!)")
            } else {
                print("interruption ended:\n\(n.userInfo!)")
                guard let opt = n.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt else {return}
                let opts = AVAudioSessionInterruptionOptions(rawValue: opt)
                if opts.contains(.shouldResume) {
                    print("should resume")
                    self?.player.prepareToPlay()
                    let ok = self?.player.play()
                    print("bp tried to resume play: did I? \(ok)")
                } else {
                    print("not should resume")
                }
            }
        }
    }

    func playFile(atPath path:String) {
        self.player?.delegate = nil
        self.player?.stop()
        let fileURL = URL(fileURLWithPath: path)
        print("bp making a new Player")
        guard let p = try? AVAudioPlayer(contentsOf: fileURL) else {return} // nicer
        self.player = p
        // error-checking omitted

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        // try this, to prove that mixable _background_ sound is not interrupted by nonmixable foreground sound
        // I find this kind of weird; you aren't allowed to interrupt any sound you want to interrupt?
        // try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)

        self.player.prepareToPlay()
        self.player.delegate = self

        if self.forever {
            self.player.numberOfLoops = -1
        }

        /// cool feature
        //player.enableRate = true
        //player.rate = 1.2

        let ok = player.play() //player.play()
        print("bp or interrupter trying to play \(path): \(ok)")

        // cute little demo
        let mpic = MPNowPlayingInfoCenter.default()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:"This Is a Test",
            MPMediaItemPropertyArtist:"Matt Neuburg"
        ]
    }


    func playFile(at fileURL:URL) {
        player?.delegate = nil
        player?.stop()
        player = try! AVAudioPlayer(contentsOf: fileURL)
        // error-checking omitted
        player.prepareToPlay()
        player.delegate = self
        if self.forever {
            self.player.numberOfLoops = -1
        }
        player.play()
    }

    // to hear about interruptions, in iOS 8, use the session notifications
    func stop () {
        player?.pause()
    }

    deinit {
        player?.delegate = nil
    }

    //MARK: - delegate method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let sess = AVAudioSession.sharedInstance()
        // this is the key move
        try? sess.setActive(false, with: .notifyOthersOnDeactivation)
        // now go back to ambient
        try? sess.setCategory(AVAudioSessionCategoryAmbient)
        try? sess.setActive(true)
        delegate?.soundFinished(self)
    }

}
