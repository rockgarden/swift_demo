
import UIKit
/// 音频工具箱框架提供用于录制，回放和流解析的接口。 在iOS中，该框架提供了用于管理音频会话的附加接口。
import AudioToolbox

func SoundFinished(_ snd:UInt32, _ c:UnsafeMutableRawPointer?) -> Void {
    print("finished!")
    AudioServicesRemoveSystemSoundCompletion(snd)
    AudioServicesDisposeSystemSoundID(snd)
}


class Root_MediaDemo: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "main"
    }

    // test on device (doesn't work in simulator)

    /// AudioServicesPlaySystemSound将被弃用！改用AudioServicesPlaySystemSoundWithCompletion
    @IBAction func doButton1 (_ sender: Any!) {
        let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        AudioServicesAddSystemSoundCompletion(snd, nil, nil, SoundFinished, nil)
        AudioServicesPlaySystemSound(snd)
    }

    @IBAction func doButton2 (_ sender: Any!) {
        let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        // watch _this_ little move
        AudioServicesAddSystemSoundCompletion(snd, nil, nil, {
            sound, context in
            print("finished!")
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
        }, nil)
        AudioServicesPlaySystemSound(snd)
    }

    /// iOS 9方式：在一个通话中传递声音和完成处理程序: pass the sound and the completion handler all in one call
    @IBAction func doButton3 (_ sender: Any!) {
        let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        AudioServicesPlaySystemSoundWithCompletion(snd) {
            AudioServicesDisposeSystemSoundID(snd)
            print("finished!")
        }
    }
    
}
