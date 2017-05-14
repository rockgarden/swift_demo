
import UIKit
import AudioToolbox

func SoundFinished(_ snd:UInt32, _ c:UnsafeMutableRawPointer?) -> Void {
    print("finished!")
    AudioServicesRemoveSystemSoundCompletion(snd)
    AudioServicesDisposeSystemSoundID(snd)
}


class Root_MediaDemo: UITableViewController {

    // test on device (doesn't work in simulator)

    // NB AudioServicesPlaySystemSound will be deprecated! This is just to show the old way

    @IBAction func doButton1 (_ sender: Any!) {
        let sndurl = Bundle.main.url(forResource:"test", withExtension: "aif")!
        var snd : SystemSoundID = 0
        AudioServicesCreateSystemSoundID(sndurl as CFURL, &snd)
        // ... or could be defined here
        // but it can't be a method
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

    // cool new iOS 9 way: pass the sound and the completion handler all in one call
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
