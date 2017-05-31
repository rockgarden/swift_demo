// Demo attitude Rotation

import UIKit
import CoreMotion

class CMMotionManagerVC: UIViewController {

    var motman = CMMotionManager()
    var timer : Timer!

    @IBOutlet var v : MyView!
    @IBOutlet var label : UILabel!
    var ref : CMAttitude!

    var polltimer : Timer!
    var canceltimer : Timer!

    var oldX = 0.0
    var oldY = 0.0
    var oldZ = 0.0
    var oldTime : TimeInterval = 0
    var lastSlap = Slap.unknown
    var state = State.unknown

    @IBAction func doButton (_ sender: Any!) {
        self.ref = nil //重新初始化, start over if user presses button again
        guard self.motman.isDeviceMotionAvailable else {
            print("oh well")
            return
        }
        /// Describes the same reference frame as xArbitraryZVertical except that the magnetometer, when available and calibrated, is used to improve long-term yaw accuracy. Using this constant instead of xArbitraryZVertical results in increased CPU usage. 描述与xArbitraryZVertical相同的参考系，除非在磁力计可用和校准的情况下，用于提高长期偏航精度。 使用这个常量而不是xArbitraryZVertical导致CPU使用率的增加。
        let ref = CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical
        let avail = CMMotionManager.availableAttitudeReferenceFrames()
        guard avail.contains(ref) else {
            print("darn")
            return
        }
        self.motman.deviceMotionUpdateInterval = 1.0 / 20.0
        self.motman.startDeviceMotionUpdates(using: ref)
        let t = 1.0 / 10.0
        self.timer = Timer.scheduledTimer(timeInterval:t, target:self, selector:#selector(pollAttitude),userInfo:nil, repeats:true)
    }

    func pollAttitude(_: Any!) {
        guard let mot = self.motman.deviceMotion else {return}
        let att = mot.attitude
        if self.ref == nil {
            self.ref = att
            print("got ref \(att.pitch), \(att.roll), \(att.yaw)")
            return
        }
        att.multiply(byInverseOf: self.ref)
        let r = att.rotationMatrix

        var t = CATransform3DIdentity
        // even more Swift numeric barf
        t.m11 = CGFloat(r.m11)
        t.m12 = CGFloat(r.m12)
        t.m13 = CGFloat(r.m13)
        t.m21 = CGFloat(r.m21)
        t.m22 = CGFloat(r.m22)
        t.m23 = CGFloat(r.m23)
        t.m31 = CGFloat(r.m31)
        t.m32 = CGFloat(r.m32)
        t.m33 = CGFloat(r.m33)

        let lay = self.v.layer.sublayers![0]
        CATransaction.setAnimationDuration(1.0/10.0)
        lay.transform = t
    }

    @IBAction func doGyro (_ sender: Any!) {
        guard self.motman.isDeviceMotionAvailable else {
            print("Oh, well")
            return
        }
        // idiot Swift numeric foo (different in iOS 8.3 but still idiotic)
        let ref = CMAttitudeReferenceFrame.xMagneticNorthZVertical
        let avail = CMMotionManager.availableAttitudeReferenceFrames()
        guard avail.contains(ref) else {
            print("darn")
            return
        }
        self.motman.showsDeviceMovementDisplay = true
        self.motman.deviceMotionUpdateInterval = 1.0 / 30.0
        self.motman.startDeviceMotionUpdates(using: ref)
        let t = self.motman.deviceMotionUpdateInterval * 10
        self.timer = Timer.scheduledTimer(timeInterval:t, target:self, selector:#selector(pollAttitude_gyro),userInfo:nil, repeats:true)

        print("starting")
    }

    func pollAttitude_gyro(_: Any!) {
        guard let mot = self.motman.deviceMotion else {return}
        // more idiotic Swift numeric foo
        let acc = mot.magneticField.accuracy.rawValue
        if acc <= CMMagneticFieldCalibrationAccuracy.low.rawValue {
            print(acc)
            return // not ready yet
        }
        let att = mot.attitude
        let to_deg = 180.0 / .pi
        print("\(att.pitch * to_deg), \(att.roll * to_deg), \(att.yaw * to_deg)")
        let g = mot.gravity
        let whichway = g.z > 0 ? "forward" : "back"
        print("pitch is tilted \(whichway)")
    }
}

extension CMMotionManagerVC {

    enum Slap {
        case unknown
        case left
        case right
    }

    @IBAction func doSmackMe (_ sender: Any!) {
        if !self.motman.isAccelerometerAvailable {
            print("Oh, well")
            return
        }
        print("starting")
        self.motman.accelerometerUpdateInterval = 1.0 / 30.0
        self.motman.startAccelerometerUpdates()
        self.polltimer = Timer.scheduledTimer(timeInterval:self.motman.accelerometerUpdateInterval, target: self, selector: #selector(pollAccel), userInfo: nil, repeats: true)
    }

    func add(acceleration accel:CMAcceleration) {
        let alpha = 0.1
        self.oldX = accel.x - ((accel.x * alpha) + (self.oldX * (1.0 - alpha)))
        self.oldY = accel.y - ((accel.y * alpha) + (self.oldY * (1.0 - alpha)))
        self.oldZ = accel.z - ((accel.z * alpha) + (self.oldZ * (1.0 - alpha)))
    }

    func pollAccel(_: Any!) {
        guard let data = self.motman.accelerometerData else {return}
        self.add(acceleration: data.acceleration)
        let x = self.oldX
        let thresh = 1.0
        if x < -thresh || x > thresh {
            // print(x)
        }
        if x < -thresh {
            if data.timestamp - self.oldTime > 0.5 || self.lastSlap == .right {
                self.oldTime = data.timestamp
                self.lastSlap = .left
                //print("invalidating")
                self.canceltimer?.invalidate()
                self.canceltimer = .scheduledTimer(withTimeInterval:0.5, repeats: false) {
                    _ in print("left")
                }
            }
        } else if x > thresh {
            if data.timestamp - self.oldTime > 0.5 || self.lastSlap == .left {
                self.oldTime = data.timestamp
                self.lastSlap = .right
                //print("invalidating")
                self.canceltimer?.invalidate()
                self.canceltimer = .scheduledTimer(withTimeInterval:0.5, repeats: false) {
                    _ in print("right")
                }
            }
        }
    }
}

extension CMMotionManagerVC {

    enum State {
        case unknown
        case lyingDown
        case notLyingDown
    }

    func stopAccelerometer () {
        self.timer?.invalidate()
        self.timer = nil
        self.motman.stopAccelerometerUpdates()
        self.label.text = ""
        (oldX, oldY, oldZ, state) = (0,0,0,.unknown)
    }

    @IBAction func doLyingDown (_ sender: Any!) {
        if self.motman.isAccelerometerActive {
            self.stopAccelerometer()
            return
        }
        guard self.motman.isAccelerometerAvailable else {
            print("Oh, well")
            return
        }
        self.motman.accelerometerUpdateInterval = 1.0 / 30.0

        var which : Int { return 1 }
        switch which {
        case 1:
            self.motman.startAccelerometerUpdates()
            self.timer = Timer.scheduledTimer(timeInterval:self.motman.accelerometerUpdateInterval, target: self, selector: #selector(pollAccelLyingDown), userInfo: nil, repeats: true)
        case 2:
            self.motman.startAccelerometerUpdates(to: .main) { data, err in
                guard let data = data else {
                    print(err as Any)
                    self.stopAccelerometer()
                    return
                }
                self.receive(acceleration:data)
            }
        default:break
        }
    }

    func pollAccelLyingDown (_: Any!) {
        guard let data = self.motman.accelerometerData else {return}
        self.receive(acceleration:data)
    }

    func addLyingDown(acceleration accel:CMAcceleration) {
        let alpha = 0.1
        self.oldX = accel.x * alpha + self.oldX * (1.0 - alpha)
        self.oldY = accel.y * alpha + self.oldY * (1.0 - alpha)
        self.oldZ = accel.z * alpha + self.oldZ * (1.0 - alpha)
    }

    func receive(acceleration data:CMAccelerometerData) {
        self.addLyingDown(acceleration: data.acceleration)
        let x = self.oldX
        let y = self.oldY
        let z = self.oldZ
        let accu = 0.08
        if abs(x) < accu && abs(y) < accu && z < -0.5 {
            if self.state == .unknown || self.state == .notLyingDown {
                self.state = .lyingDown
                self.label.text = "I'm lying on my back... ahhh..."
            }
        } else {
            if self.state == .unknown || self.state == .lyingDown {
                self.state = .notLyingDown
                self.label.text = "Hey, put me back down on the table!"
            }
        }
    }
}

