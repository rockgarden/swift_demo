

import UIKit
import AVFoundation

struct Oncer2 {
    private static var once : Void = {
        print("I did it too!")
    }()
    func doThisOnce() {
        _ = type(of:self).once
    }
}
let oncer2 = Oncer2()


class MandelbrotVC_GCD: UIViewController {

    @IBOutlet var mv : GCDMandelbrotView!
    
    @IBAction func doButton (_ sender: Any!) {
        self.mv.drawThatPuppy()
    }
    
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
        /// DispatchQueue管理工作项的执行。 提交到队列的每个工作项都由系统管理的线程池进行处理。
        DispatchQueue.global(qos: .background).async {
            let queue = DispatchQueue(label:"com.rockgarden.groupq", attributes:.concurrent)
            /// DispatchGroup允许工作的聚合同步。 您可以使用它们提交多个不同的工作项，并跟踪它们何时完成，即使它们可能在不同的队列上运行。当所有指定的任务完成之前, progress can’t be made，此行为可能会有所帮助。
            let group = DispatchGroup()

            /// 明确地表示块已经进入组。
            group.enter()
            queue.async {
                delay(Double(arc4random_uniform(10))) {
                    print("finished 1")
                    /// 明确表示组中的块已经完成。调用此函数会减少组中未完成任务的当前计数。使用此函数（使用enter（））可以让应用程序通过除了使用dispatch_group_async（_：_：_ :)函数之外的方式显式添加和删除组中的任务，从而正确地管理任务引用计数。对此函数的调用必须和调用enter（）相当。调用它比enter（）更多次，这将导致计数为负。
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


/// just testing syntax
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

    //定义一个队列
    let queue:DispatchQueue
    //用于保持结果的变量
    var result:String?

    func getResult(block:@escaping (String)->Void) -> Void{
        //挂起队列
        queue.suspend()
        //将回调处理加入队列
        queue.async{
            block(self.result!)
        }
    }

    func locationManager() {
        guard result != nil else {
            result = "ok"
            queue.resume()
            return
        }
    }
}
