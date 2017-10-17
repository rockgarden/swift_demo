//
//  AVAudioEngineTestVC.swift
//  MediaPlayerDemo
//

import UIKit
import AVFoundation

// warning: turn off your "All Exceptions" breakpoint

class AVAudioEngineTestVC: UIViewController {

    var audioPlayer : AVAudioPlayer!
    var engine = AVAudioEngine()
    let m4aUrl = Bundle.main.url(forResource:"aboutTiagol", withExtension:"m4a")!
    let mp3Url = Bundle.main.url(forResource:"Hooded", withExtension: "mp3")!

    /// AVAudioPlayerNode
    @IBAction func doButton(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()
        // take out a player node
        let player = AVAudioPlayerNode()
        self.engine.attach(player)

        // open a file to play on the player node
        let f = try! AVAudioFile(forReading: m4aUrl)
        /// 将播放器的输出挂接到self.engine的混音器节点; 或者，可以使用self.engine的输出节点（混合器已挂接输出）hook the player's output to the self.engine's mixer node. alternatively, could use the self.engine's output node (mixer is hooked to output already)
        let mixer = self.engine.mainMixerNode
        self.engine.connect(player, to: mixer, format: f.processingFormat)

        // schedule the file on the player
        player.scheduleFile(f, at:nil)
        // start the self.engine
        self.engine.prepare()
        try! self.engine.start()
        player.play()
    }

    /// AVAudioPCMBuffer
    @IBAction func doButton2(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        self.engine.attach(player)

        /// simplest possible "play a buffer" scenario
        let f = try! AVAudioFile(forReading: mp3Url)
        let buffer = AVAudioPCMBuffer(pcmFormat: f.processingFormat, frameCapacity: UInt32(f.length /* /3 */)) // only need 1/3 of the original recording
        try! f.read(into:buffer!)

        let mixer = self.engine.mainMixerNode
        self.engine.connect(player, to: mixer, format: f.processingFormat)

        player.scheduleBuffer(buffer!)
        self.engine.prepare()
        try! self.engine.start()
        player.play()
    }

    private func basePlayer(_ f: AVAudioFile) {

    }

    @IBAction func doButton3(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()

        let player = AVAudioPlayerNode()
        let f = try! AVAudioFile(forReading: m4aUrl)
        let mixer = self.engine.mainMixerNode
        self.engine.attach(player)
        self.engine.connect(player, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil) {print("done")}
        self.engine.prepare()
        try! self.engine.start()
        player.play()

        let f2 = try! AVAudioFile(forReading: mp3Url)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length/3))
        try! f2.read(into:buffer!)
        let player2 = AVAudioPlayerNode()
        self.engine.attach(player2)
        self.engine.connect(player2, to: mixer, format: f2.processingFormat)
        player2.scheduleBuffer(buffer!, at: nil, options: .loops)

        // mix down a little
        player2.volume = 0.3
        player2.play()
    }


    @IBAction func doButton4(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()

        // first sound
        let player = AVAudioPlayerNode()
        let f = try! AVAudioFile(forReading: m4aUrl)
        self.engine.attach(player)

        // add some effect nodes to the chain
        let effect = AVAudioUnitTimePitch()
        effect.rate = 0.9
        effect.pitch = -300
        self.engine.attach(effect)
        self.engine.connect(player, to: effect, format: f.processingFormat)
        let effect2 = AVAudioUnitReverb()
        effect2.loadFactoryPreset(.cathedral)
        effect2.wetDryMix = 40
        self.engine.attach(effect2)
        self.engine.connect(effect, to: effect2, format: f.processingFormat)

        // patch last node into self.engine mixer and start playing first sound
        let mixer = self.engine.mainMixerNode
        self.engine.connect(effect2, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil)
        self.engine.prepare()
        try! self.engine.start()
        player.play()

        // second sound; loop it this time
        let f2 = try! AVAudioFile(forReading: mp3Url)
        let buffer = AVAudioPCMBuffer(pcmFormat: f2.processingFormat, frameCapacity: UInt32(f2.length /* /3 */))
        try! f2.read(into:buffer!)
        let player2 = AVAudioPlayerNode()
        self.engine.attach(player2)
        self.engine.connect(player2, to: mixer, format: f2.processingFormat)
        player2.scheduleBuffer(buffer!, at: nil, options: .loops)

        // mix down a little, start playing second sound
        player.pan = -0.5
        player2.volume = 0.5
        player2.pan = 0.5
        player2.play()

        print("volume: \(player.volume)")
    }


    /// new iOS 9 feature: split node
    @IBAction func doButton4a(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()

        // first sound
        let player = AVAudioPlayerNode()

        let f = try! AVAudioFile(forReading: m4aUrl)
        self.engine.attach(player)

        // add some effect nodes to the chain
        let effect = AVAudioUnitDelay()
        effect.delayTime = 0.4
        effect.feedback = 0
        self.engine.attach(effect)
        let effect2 = AVAudioUnitReverb()
        effect2.loadFactoryPreset(.cathedral)
        effect2.wetDryMix = 40
        self.engine.attach(effect2)

        let mixer = self.engine.mainMixerNode

        // patch player node to _both_ effect nodes _and_ the mixer
        let cons = [
            AVAudioConnectionPoint(node: effect, bus: 0),
            AVAudioConnectionPoint(node: effect2, bus: 0),
            AVAudioConnectionPoint(node: mixer, bus: 1),
            ]
        self.engine.connect(player, to: cons, fromBus: 0, format: f.processingFormat)

        // patch both effect nodes into the mixer
        self.engine.connect(effect, to: mixer, format: f.processingFormat)
        self.engine.connect(effect2, to: mixer, format: f.processingFormat)
        player.scheduleFile(f, at: nil)
        self.engine.prepare()
        try! self.engine.start()
        player.play()

        print(player.volume)
    }


    /// create the output file
    @IBAction func doButton5(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()

        // simple minimal file-writing example
        // you have to form a valid file format or you'll get an error up front
        // also, it's a little disappointing to find that you must _play_ the sound...
        let f = try! AVAudioFile(forReading: mp3Url)
        let buffer = AVAudioPCMBuffer(pcmFormat: f.processingFormat, frameCapacity: UInt32(f.length /* /3 */)) // only need 1/3 of the original recording
        try! f.read(into:buffer!)

        let player2 = AVAudioPlayerNode()
        self.engine.attach(player2)

        let effect = AVAudioUnitReverb()
        effect.loadFactoryPreset(.cathedral)
        effect.wetDryMix = 40
        self.engine.attach(effect)

        self.engine.connect(player2, to: effect, format: f.processingFormat)
        let mixer = self.engine.mainMixerNode
        self.engine.connect(effect, to: mixer, format: f.processingFormat)

        /// create the output file
        let fm = FileManager.default
        let doc = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let outurl = doc.appendingPathComponent("myfile.aac", isDirectory:false)

        let outfile = try! AVAudioFile(forWriting: outurl, settings: [
            AVFormatIDKey : kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey : 1,
            AVSampleRateKey : 22050,
            ])

        /// we'll know when the input buffer is emptied, but the sound will still be going on, because of the reverb; so to detect when the sound has faded away, we watch for the last output buffer value to become very small

        // install a tap on the reverb effect node
        var done = false // flag: don't stop until input buffer is empty!
        effect.installTap(onBus:0, bufferSize: 4096, format: outfile.processingFormat) {
            buffer, time in
            let dataptrptr = buffer.floatChannelData!
            let dataptr = dataptrptr.pointee
            let datum = dataptr[Int(buffer.frameLength) - 1]
            // stop when input is empty and sound is very quiet
            if done && abs(datum) < 0.000001 {
                print("stopping")
                player2.stop()
                self.engine.stop()
                self.engine.reset()
                // let's prove we recorded it!
                self.playSound(outurl)
                return
            }
            do {
                try outfile.write(from:buffer)
            } catch {
                print(error)
            }
        }

        player2.scheduleBuffer(buffer!) {
            done = true
        }

        self.engine.prepare()
        try! self.engine.start()
        player2.play()
    }


    @IBAction func doStop(_ sender: Any) {
        self.engine.stop()
        self.engine = AVAudioEngine()

        guard (audioPlayer != nil) else {return}
        audioPlayer.stop()
    }

    private func playSound(_ url: URL) {
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOf: url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            self.audioPlayer.delegate = self
            print("starting to play?")
        } catch { print("failed to create audio player from \(url)") }
    }
}


extension AVAudioEngineTestVC : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")
    }
}
