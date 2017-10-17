//
//  AVPlayerLayerVC.swift
//  MediaPlayerDemo
//

import UIKit
import AVFoundation
import AVKit

/// AVKit Composition
class AVCompositionVC: UIViewController {

    var synchLayer : AVSynchronizedLayer! //AVSynchronizedLayer是具有与特定AVPlayerItem同步的层定时的CALayer子类。您可以从同一个AVPlayerItem对象创建任意数量的同步图层。同步图层类似于CATransformLayer对象，因为它不显示任何内容，它只是赋予其层子树上的状态。AVSynchronizedLayer赋予其定时状态，使其子树中的层次与播放器项目的时间同步。

    override func viewDidLoad() {
        super.viewDidLoad()

        let m = Bundle.main.url(forResource:"ElMirage", withExtension:"mp4")!
        let asset = AVURLAsset(url:m)
        let item = AVPlayerItem(asset: asset)
        let p = AVPlayer(playerItem: item)
        p.addObserver(self, forKeyPath:#keyPath(AVPlayer.status), context:nil)

        let vc = AVPlayerViewController()
        vc.player = p
        vc.view.frame = CGRect(10,74,300,200)
        /// 加载速度慢时为true, looks nicer if it don't show until ready
        vc.view.isHidden = true
        addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.status) {
            DispatchQueue.main.async {
                // 加载完 AVPlayer 后构造 synchLayer
                self.finishConstructingInterface()
            }
        }
    }

    private func finishConstructingInterface () {
        let vc = self.childViewControllers[0] as! AVPlayerViewController
        let p = vc.player!
        if p.status != .readyToPlay {
            return
        }
        p.removeObserver(self, forKeyPath:#keyPath(AVPlayer.status))
        vc.view.isHidden = false

        // 重置
        if synchLayer?.superlayer != nil {
            synchLayer.removeFromSuperlayer()
        }

        // create synch layer, put it in the interface
        let item = p.currentItem!
        let syncLayer = AVSynchronizedLayer(playerItem: item)
        syncLayer.frame = CGRect(10,284,300,10)
        syncLayer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(syncLayer)
        // give synch layer a sublayer
        let subLayer = CALayer()
        subLayer.backgroundColor = UIColor.black.cgColor
        subLayer.frame = CGRect(0,0,10,10)
        syncLayer.addSublayer(subLayer)
        // animate the sublayer
        let anim = CABasicAnimation(keyPath:#keyPath(CALayer.position))
        anim.fromValue = subLayer.position
        anim.toValue = CGPoint(295,5)
        anim.isRemovedOnCompletion = false
        anim.beginTime = AVCoreAnimationBeginTimeAtZero //important trick: 使用此常量将CoreAnimation的动画beginTime属性设置为0。常数是一个小的，非零的正值，可以防止CoreAnimation用CACurrentMediaTime替换0.0，
        anim.duration = CMTimeGetSeconds(item.asset.duration)
        subLayer.add(anim, forKey:nil)

        self.synchLayer = syncLayer
    }


    /// the AVPlayerViewController's player's item's asset...can be a mutable composition
    @IBAction func doButton2 (_ sender: Any!) {
        let vc = childViewControllers[0] as! AVPlayerViewController
        let p = vc.player!
        p.pause()

        let asset1 = p.currentItem!.asset

        let type = AVMediaType.video
        let arr = asset1.tracks(withMediaType: type)
        let track = arr.last!

        let duration : CMTime = track.timeRange.duration

        let comp = AVMutableComposition() //AVMutableComposition是当您想从现有资产创建新构图时使用的AVComposition的一个可变子类。您可以添加和删除曲目，您可以添加，删除和缩放时间范围。您可以制作不可变的快照，以便播放或检查可变组合物
        
        let comptrack = comp.addMutableTrack(withMediaType: type,
                                             preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        try! comptrack?.insertTimeRange(CMTimeRange(start: CMTime(seconds:0, preferredTimescale:600), duration: CMTime(seconds:5, preferredTimescale:600)), of:track, at:CMTime(seconds:0, preferredTimescale:600))
        try! comptrack?.insertTimeRange(CMTimeRange(start: CMTimeSubtract(duration, CMTime(seconds:5, preferredTimescale:600)), duration: CMTime(seconds:5, preferredTimescale:600)), of:track, at:CMTime(seconds:5, preferredTimescale:600))

        let type2 = AVMediaType.audio
        let arr2 = asset1.tracks(withMediaType: type2)
        let track2 = arr2.last!

        let comptrack2 = comp.addMutableTrack(withMediaType: type2, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        try! comptrack2?.insertTimeRange(CMTimeRange(start: CMTime(seconds:0, preferredTimescale:600), duration: CMTime(seconds:5, preferredTimescale:600)), of:track2, at:CMTime(seconds:0, preferredTimescale:600))
        try! comptrack2?.insertTimeRange(CMTimeRange(start: CMTimeSubtract(duration, CMTime(seconds:5, preferredTimescale:600)), duration: CMTime(seconds:5, preferredTimescale:600)), of:track2, at:CMTime(seconds:5, preferredTimescale:600))

        let type3 = AVMediaType.audio
        let s = Bundle.main.url(forResource:"aboutTiagol", withExtension:"m4a")!
        let asset2 = AVURLAsset(url:s)
        let arr3 = asset2.tracks(withMediaType: type3)
        let track3 = arr3.last!

        let comptrack3 = comp.addMutableTrack(withMediaType: type3, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        try! comptrack3?.insertTimeRange(CMTimeRange(start: CMTime(seconds:0, preferredTimescale:600), duration: CMTime(seconds:10, preferredTimescale:600)), of:track3, at:CMTime(seconds:0, preferredTimescale:600))

        let params = AVMutableAudioMixInputParameters(track:comptrack3)
        params.setVolume(1, at:CMTime(seconds:0, preferredTimescale:600))
        params.setVolumeRamp(fromStartVolume: 1, toEndVolume:0, timeRange:CMTimeRange(start: CMTime(seconds:7, preferredTimescale:600), duration: CMTime(seconds:3, preferredTimescale:600)))
        let mix = AVMutableAudioMix()
        mix.inputParameters = [params]

        let item = AVPlayerItem(asset:comp)
        item.audioMix = mix

        // note this cool trick! the status won't change, so to trigger a KVO notification, ...we supply the .Initial option
        p.addObserver(self, forKeyPath:#keyPath(AVPlayer.status), options:.initial, context:nil)
        p.replaceCurrentItem(with: item)
        (sender as! UIControl).isEnabled = false
    }
    
}
