// !!! Important need M7 equipped devices
// http://www.jianshu.com/p/e5f332f9b27c

import UIKit
import CoreMotion

class CMMotionActivityVC: UITableViewController {
    
    let actman = CMMotionActivityManager()
    var isAuthorized = true
    var data : [CMMotionActivity]!
    var queue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(doStart))
        navigationItem.rightBarButtonItem = b
        
        let ok2 = CMPedometer.isStepCountingAvailable()
        print("pedometer: \(ok2)")
        let ok3 = CMPedometer.isDistanceAvailable()
        print("distance: \(ok3)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkAuthorization()
    }

    func checkAuthorization() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            print("darn")
            return
        }
        //  there is also CMPedometer and various is...Available in iOS 8 on a subset of devices
        /// 没有直接的授权检查? there is no direct authorization check
        //  instead, we attempt to "tickle" the activity manager and see if we get an error
        //  this will cause the system authorization dialog to be presented if necessary
        let now = Date()
        self.actman.queryActivityStarting(from: now, to:now, to:.main) { arr, err in
            // such Swift numeric barf you could plotz
            let notauth = Int(CMErrorMotionActivityNotAuthorized.rawValue)
            if err != nil && (err! as NSError).code == notauth {
                print("no authorization")
                self.isAuthorized = false
            } else {
                print("authorized")
                self.isAuthorized = true
            }
        }
    }
    
    func doStart(_ sender: Any!) {
        if !self.isAuthorized {
            self.checkAuthorization()
            return
        }

        /// there are two approaches: live and historical
        /// collect historical data
        let now = Date()
        let yester = now - (60*60*24) // !
        self.actman.queryActivityStarting(from: yester, to: now, to: self.queue) { arr, err in
            guard var acts = arr else {return}
            /// crude filter: 粗过滤器：消除空白，低信度和连续重复 eliminate empties, low-confidence, and successive duplicates
            let blank = "f f f f f f"
            acts = acts.filter {act in act.overallAct() != blank}
            acts = acts.filter {act in act.confidence == .high}
            acts = acts.filter {act in !(act.automotive && act.stationary)}
            for i in (1..<acts.count).reversed() {
                if acts[i].overallAct() == acts[i-1].overallAct() {
                    print("removing act identical to previous")
                    acts.remove(at:i)
                }
            }
            DispatchQueue.main.async {
                self.data = acts
                self.tableView.reloadData()
            }
            /*
            let format = DateFormatter()
            format.dateFormat = "MMM d, HH:mm:ss"
            
            for act in acts {
                print("=======")
                print(format.string(from:act.startDate))
                print("S W R A U")
                // print(self.overallAct(act))
            }
            */
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.data != nil {
            return 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data != nil {
            return self.data.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) 

        let act = self.data[indexPath.row]
        let format = DateFormatter()
        format.dateFormat = "MMM d, HH:mm:ss"
        cell.textLabel!.text = format.string(from: act.startDate)
        cell.detailTextLabel!.text = act.overallAct()
        
        cell.backgroundColor = .white
        if act.automotive {
            cell.backgroundColor = .red
        }
        if act.walking || act.running {
            cell.backgroundColor = .green
        }
        return cell
    }
}


fileprivate extension CMMotionActivity {

    private func tf(_ b:Bool) -> String {
        return b ? "t" : "f"
    }

    func overallAct() -> String {
        let s = tf(self.stationary)
        let w = tf(self.walking)
        let r = tf(self.running)
        let a = tf(self.automotive)
        let c = tf(self.cycling)
        let u = tf(self.unknown)
        return "\(s) \(w) \(r) \(a) \(c) \(u)"
    }
}
