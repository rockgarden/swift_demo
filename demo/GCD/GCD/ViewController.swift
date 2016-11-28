//
//  ViewController.swift
//  GCD
//
//  Created by wangkan on 2016/11/28.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import AVFoundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}


struct Oncer2 {
    private static var once : Void = {
        print("I did it too!")
    }()
    func doThisOnce() {
        _ = type(of:self).once
    }
}
let oncer2 = Oncer2()


class MandelbrotGCDVC: UIViewController {

    struct Oncer {
        private static var once : Void = {
            print("I did it!")
        }()
        func doThisOnce() {
            _ = type(of:self).once
        }
    }
    let oncer = Oncer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.testOnce()
        self.testDispatchGroups()
    }

    func testOnce() {
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        self.oncer.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
        oncer2.doThisOnce()
    }

    func testDispatchGroups() {
        DispatchQueue.global(qos: .background).async {
            let queue = DispatchQueue(label:"com.rockgarden.GCD", attributes:.concurrent)
            let group = DispatchGroup()

            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 1")
                    group.leave()
                }
            }

            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 2")
                    group.leave()
                }
            }

            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 3")
                    group.leave()
                }
            }

            group.notify(queue: DispatchQueue.main) {
                print("All async calls were run!")
            }
        }
    }
}

// not used, just testing syntax

class AssetTester : NSObject {
    let assetQueue = DispatchQueue(label: "testing.testing")
    func getAssetInternal() -> AVAsset {
        return AVAsset()
    }
    func asset() -> AVAsset? {
        var theAsset : AVAsset!
        self.assetQueue.sync {
            theAsset = self.getAssetInternal().copy() as! AVAsset
        }
        return theAsset
    }
}

