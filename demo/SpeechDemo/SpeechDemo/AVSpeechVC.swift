//
//  AVSpeechVC.swift
//  SpeechDemo
//

import UIKit
import AVFoundation

/// Text To Speech
class AVSpeechVC: UIViewController, AVSpeechSynthesizerDelegate {

    var talker = AVSpeechSynthesizer()

    @IBAction func talk (_ sender: Any!) {
        let utter = AVSpeechUtterance(string:"Polly, want a cracker?")
        // print(AVSpeechSynthesisVoice.speechVoices())
        let v = AVSpeechSynthesisVoice(language: "en-US")
        utter.voice = v

        //var rate = AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate
        //rate = rate * 0.15 + AVSpeechUtteranceMinimumSpeechRate
        //utter.rate = rate

        self.talker.delegate = self
        self.talker.speak(utter)

        print(v?.identifier as Any)
        print(v?.quality.rawValue as Any)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("starting")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("finished")
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let s = (utterance.speechString as NSString).substring(with:characterRange)
        print("about to say \(s)")
    }

}
