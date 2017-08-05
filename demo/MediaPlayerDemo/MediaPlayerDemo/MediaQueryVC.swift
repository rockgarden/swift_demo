//
//  MediaQueryVC.swift
//  MediaPlayerDemo
//

import UIKit
import MediaPlayer

class MediaQueryVC: UIViewController {

    var q : MPMediaItemCollection!
    @IBOutlet var label : UILabel!
    var timer : Timer!
    @IBOutlet var prog : UIProgressView!
    @IBOutlet var vv : MPVolumeView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let sz = CGSize(20,20)
        let r = UIGraphicsImageRenderer(size:sz)
        let im1 = r.image {
            _ in
            UIColor.black.setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }
        let im2 = r.image {
            _ in
            UIColor.red.setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }
        let im3 = r.image {
            _ in
            UIColor.orange.setFill()
            UIBezierPath(ovalIn:
                CGRect(0,0,sz.height,sz.height)).fill()
        }

        self.vv.setMinimumVolumeSliderImage(
            im1.resizableImage(withCapInsets:UIEdgeInsetsMake(9,9,9,9),
                               resizingMode:.stretch),
            for:.normal)
        self.vv.setMaximumVolumeSliderImage(
            im2.resizableImage(withCapInsets:UIEdgeInsetsMake(9,9,9,9),
                               resizingMode:.stretch),
            for:.normal)

        /// 音量限制: only for EU devices; to test, use the EU Volume Limit switch under Developer settings on device
        self.vv.volumeWarningSliderImage =
            im3.resizableImage(withCapInsets:UIEdgeInsetsMake(9,9,9,9),
                               resizingMode:.stretch)

        let sz2 = CGSize(40,40)
        let r2 = UIGraphicsImageRenderer(size:sz2)
        let thumb = r2.image {_ in
            UIImage(named:"SmileyRound.png")!.draw(in:CGRect(origin:.zero,size:sz2))
        }
        self.vv.setVolumeThumbImage(thumb, for:.normal)


        NotificationCenter.default.addObserver(self, selector:#selector(wirelessChanged),
                                               name:.MPVolumeViewWirelessRoutesAvailableDidChange,
                                               object:nil)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(wirelessChanged2),
                                               name:.MPVolumeViewWirelessRouteActiveDidChange,
                                               object:nil)

    }

    func wirelessChanged(_ n:Notification) {
        print("wireless change \(String(describing: n.userInfo))")
    }
    func wirelessChanged2(_ n:Notification) {
        print("wireless active change \(String(describing: n.userInfo))")
    }

    func dummy() {

    }

    @IBAction func doAllAlbumTitles (_ sender: Any!) {
        //checkForMusicLibraryAccess(andThen:self.dummy)
        checkForMusicLibraryAccess {
            do {
                let query = MPMediaQuery()
                let result = query.items
                _ = result
            }
            let query = MPMediaQuery.albums()
            guard let result = query.collections else {return} //
            /// prove we've performed the query, by logging the album titles
            for album in result {
                print(album.representativeItem!.albumTitle!) //
            }

            // cloud item values are 0 and 1, meaning false and true
            for album in result {
                for song in album.items { //
                    print("\(song.isCloudItem) \(String(describing: song.assetURL)) \(String(describing: song.title))")
                }
            }
            return
        }
    }

    @IBAction func doBeethovenAlbumTitles (_ sender: Any!) {
        checkForMusicLibraryAccess {
            let query = MPMediaQuery.albums()
            let hasBeethoven = MPMediaPropertyPredicate(value:"Beethoven",
                                                        forProperty:MPMediaItemPropertyAlbumTitle,
                                                        comparisonType:.contains)
            query.addFilterPredicate(hasBeethoven)
            guard let result = query.collections else {return}
            for album in result {
                print(album.representativeItem!.albumTitle!)
            }
        }
    }

    @IBAction func doSonataAlbumsOnDevice (_ sender: Any!) {
        checkForMusicLibraryAccess {
            let query = MPMediaQuery.albums()
            let hasSonata = MPMediaPropertyPredicate(value:"Sonata",
                                                     forProperty:MPMediaItemPropertyTitle,
                                                     comparisonType:.contains)
            query.addFilterPredicate(hasSonata)
            let isPresent = MPMediaPropertyPredicate(value:false,
                                                     forProperty:MPMediaItemPropertyIsCloudItem, //?string name of property incorrect in header
                comparisonType:.equalTo)
            query.addFilterPredicate(isPresent)

            guard let result = query.collections else {return} //
            for album in result {
                print(album.representativeItem!.albumTitle!)
            }
            // and here are the songs in the first of those albums
            guard result.count > 0 else {print("No sonatas"); return}
            let album = result[0]
            for song in album.items { //
                print(song.title!)
            }
        }
    }

    @IBAction func doPlayShortSongs (_ sender: Any!) {
        checkForMusicLibraryAccess {
            let query = MPMediaQuery.songs()
            // always need to filter out songs that aren't present
            let isPresent = MPMediaPropertyPredicate(value:false,
                                                     forProperty:MPMediaItemPropertyIsCloudItem,
                                                     comparisonType:.equalTo)
            query.addFilterPredicate(isPresent)
            guard let items = query.items else {return}

            let shorties = items.filter {
                let dur = $0.playbackDuration
                return dur < 3000
            }

            guard shorties.count > 0 else {
                print("no songs that short!")
                return
            }
            print("got \(shorties.count) short songs")
            let queue = MPMediaItemCollection(items:shorties)
            let player = MPMusicPlayerController.applicationMusicPlayer()
            player.stop()
            player.setQueue(with:queue)
            player.shuffleMode = .songs
            player.beginGeneratingPlaybackNotifications()
            NotificationCenter.default.addObserver(self, selector: #selector(self.changed), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: player)
            self.q = queue //retain a pointer to the queue
            player.play()

            self.timer = Timer.scheduledTimer(timeInterval:1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
            self.timer.tolerance = 0.1
        }
    }

    func changed(_ n:Notification) {
        defer {
            self.timer?.fire()
        }
        self.label.text = ""
        let player = MPMusicPlayerController.applicationMusicPlayer()
        guard let obj = n.object, obj as AnyObject === player else { return }
        guard let title = player.nowPlayingItem?.title else {return}
        let ix = player.indexOfNowPlayingItem
        guard ix != NSNotFound else {return}
        self.label.text = "\(ix+1) of \(self.q.count): \(title)"
    }

    func timerFired(_: Any) {
        let player = MPMusicPlayerController.applicationMusicPlayer()
        guard let item = player.nowPlayingItem, player.playbackState != .stopped else {
            self.prog.isHidden = true
            return
        }
        self.prog.isHidden = false
        let current = player.currentPlaybackTime
        let total = item.playbackDuration
        self.prog.progress = Float(current / total)
    }

}


class MyVolumeView : MPVolumeView {
    
    override func volumeSliderRect(forBounds bounds: CGRect) -> CGRect {
        print("slider rect", bounds)
        return super.volumeSliderRect(forBounds: bounds)
    }
    
    override func volumeThumbRect(forBounds bounds: CGRect, volumeSliderRect rect: CGRect, value: Float) -> CGRect {
        print("thumb rect", value)
        return super.volumeThumbRect(forBounds: bounds, volumeSliderRect: rect, value: value)
    }
    
}
