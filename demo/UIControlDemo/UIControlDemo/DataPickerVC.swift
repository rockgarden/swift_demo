
import UIKit

class DataPickerVC: UIViewController {
    @IBOutlet weak var dp: UIDatePicker!
    @IBOutlet weak var dpCDT: UIDatePicker!
    let which = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        //dp.datePickerMode = .date
        dp.datePickerMode = .dateAndTime
        var dc = DateComponents(year:1900, month:1, day:1, hour:1, minute:1)
        let c = Calendar(identifier:.chinese)
        let d1 = c.date(from: dc)!
        dp.minimumDate = d1
        dp.date = d1
        dc.year = 1949
        let d2 = c.date(from: dc)!
        dp.maximumDate = d2

        dpCDT.datePickerMode = .countDownTimer

    }

    @IBAction func dateChanged(_ sender: Any) {
        let dp = sender as! UIDatePicker
        if dp.datePickerMode != .countDownTimer {
            let d = dp.date
            let df = DateFormatter()
            df.timeStyle = .full
            df.dateStyle = .full
            print(df.string(from: d))
            // Tuesday, August 10, 1954 at 3:16:00 AM GMT-07:00
        } else {
            let t = dp.countDownDuration
            let f = DateComponentsFormatter()
            f.allowedUnits = [.hour, .minute]
            f.unitsStyle = .abbreviated
            if let s = f.string(from: t) {
                print(s) // "1h 12m"
            }
        }
    }

}


