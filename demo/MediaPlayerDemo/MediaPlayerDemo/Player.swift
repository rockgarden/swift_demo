

import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerDelegate : class {
    func soundFinished(_ sender: Any)
}

class Player : NSObject, AVAudioPlayerDelegate {

    var avPlayer : AVAudioPlayer!
    var forever = false
    weak var delegate : PlayerDelegate?
    var observer : NSObjectProtocol! //addObserver

    override init() {
        super.init()

        /// interruption notification
        // note (irrelevant无关 for playFile, but useful for bk 1) how to prevent retain cycle
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
                    self?.avPlayer.prepareToPlay()
                    let ok = self?.avPlayer.play()
                    print("bp tried to resume play: did I? \(String(describing: ok))")
                } else {
                    print("not should resume")
                }
            }
        }
    }

    private func newPlayer(_ path: String) {
        self.avPlayer?.delegate = nil
        self.avPlayer?.stop()
        let fileURL = URL(fileURLWithPath: path)
        print("bp making a new Player")
        guard let p = try? AVAudioPlayer(contentsOf: fileURL) else {return}
        self.avPlayer = p
    }

    func bPlayFile(atPath path: String) {
        newPlayer(path)

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)

        self.avPlayer.prepareToPlay()
        self.avPlayer.delegate = self
        let ok = avPlayer.play()
        print("bp trying to play \(path): \(ok)")
    }

    func playFile(atPath path: String) {

        /// switch to playback category while playing, interrupt background audio
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)

        /// TODO: 尝试这个，以证明可混合的_background_声音不会被不可混合的前景声音中断
        /// test this, to prove that mixable _background_ sound is not interrupted by nonmixable foreground sound. This mean you aren't allowed to interrupt any sound you want to interrupt?
        //try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)

        try? AVAudioSession.sharedInstance().setActive(true)

        newPlayer(path)
        /// 省略错误检查 error-checking omitted
        self.avPlayer.prepareToPlay()
        self.avPlayer.delegate = self

        if self.forever {
            self.avPlayer.numberOfLoops = -1
        }

        /// 一个布尔值，指定是否为音频播放器启用播放速率调整。要为音频播放器启用可调节播放速率，请在初始化播放器之后，以及在调用播放器的prepareToPlay()实例方法之前将此属性设置为true。
        avPlayer.enableRate = true
        avPlayer.rate = 1.2

        let ok = avPlayer.play()
        print("interrupter trying to play \(path): \(ok)")

        let mpic = MPNowPlayingInfoCenter.default()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:"This Is a Test",
            MPMediaItemPropertyArtist:"Matt Neuburg"
        ]
    }


    func playFile(at fileURL: URL) {
        avPlayer?.delegate = nil
        avPlayer?.stop()
        avPlayer = try! AVAudioPlayer(contentsOf: fileURL)
        avPlayer.prepareToPlay()
        avPlayer.delegate = self
        if self.forever {
            self.avPlayer.numberOfLoops = -1
        }
        avPlayer.play()
    }

    // TODO: Test to hear about interruptions, in iOS 8, use the session notifications
    func stop () {
        avPlayer?.pause()
    }

    deinit {
        print("bp player dealloc")
        if self.observer != nil {
            NotificationCenter.default.removeObserver(self.observer)
        }
        avPlayer?.delegate = nil
    }

    // MARK: - delegate method
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
