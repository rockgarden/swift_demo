//
//  MIDITestVC.swift
//  MediaPlayerDemo
//
//  http://www.jianshu.com/p/506c62183763
//  https://developer.apple.com/videos/play/wwdc2014/502/

import UIKit
import AVFoundation

class MIDITestVC: UIViewController {
    
    var player : AVMIDIPlayer!
    var engine = AVAudioEngine()
    var unit = AVAudioUnitSampler() ///不需要反复实例化
    var seq : AVAudioSequencer!

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        seq = nil
        ///seq无法自动释放, 通过强制为空 可 FIX-Error: 'com.apple.coreaudio.avfaudio', reason: 'required condition is false: outputNode' 并确保播放结束. 
        ///engine可自动释放
    }
    
    @IBAction func doButton(_ sender: Any) {
        
        let midurl = Bundle.main.url(forResource:"presto", withExtension: "mid")!
        let sndurl = Bundle.main.url(forResource:"PianoBell", withExtension: "sf2")!
        var which : Int { return 2 } // 1 or 2
        
        switch which {
        case 1:
            self.player = try! AVMIDIPlayer(contentsOf: midurl, soundBankURL: sndurl)
            self.player.prepareToPlay()
            self.player.play(nil)
        case 2:
            reset()

            //let unit = AVAudioUnitSampler() //不建议多次instance
            engine.attach(unit) ///生成 other nodes
            let mixer = engine.outputNode ///生成 output chain
            engine.connect(unit, to: mixer, format: mixer.outputFormat(forBus:0)) ///加入 inputs
            do {
                try unit.loadInstrument(at:sndurl) // do this only after configuring engine
            } catch let err  {
                debugPrint(err)
            }

            seq = AVAudioSequencer(audioEngine: engine)
            try! seq.load(from:midurl)
            
            engine.prepare()
            do {
                try engine.start()
                try seq.start()
            } catch let err  {
                debugPrint(err)
            }

        default: break
        }
        
    }

    fileprivate func reset() {
        if seq != nil {
            if seq.isPlaying {
                seq.stop()
                seq = nil
            }
        }
        if engine.isRunning {
            debugPrint(engine)
            engine.stop()
            engine.detach(unit)
            debugPrint(engine)
        }
    }

}

