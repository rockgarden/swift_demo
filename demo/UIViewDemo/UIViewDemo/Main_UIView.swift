
import UIKit

class MyPickerView : UIPickerView {
    override var intrinsicContentSize : CGSize {
        return super.intrinsicContentSize

        /// in iOS 9 you can just set the height constraint
        //        debugPrint("intrinsic")
        //        var sz = super.intrinsicContentSize
        //        let h : CGFloat = 140
        //        print("trying to set to \(h)")
        //        sz.height = h // but it only goes down to 162, maximum 180
        //        sz.width = 250 // just proving this actually does something
        //        return sz
    }
}


class Main_UIView: UIViewController {
    @IBOutlet var picker: UIPickerView!
    var vcList: [String]!
    var which = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let f = Bundle.main.path(forResource: "vcList", ofType: "txt")!
        let s = try! String(contentsOfFile: f)
        self.vcList = s.components(separatedBy:"\n")
        if vcList.last == "" { vcList.removeLast()}
        //vcList.filter {$0 == ""}
        picker.delegate = self
        picker.dataSource  = self
    }

    override func viewDidLayoutSubviews() {
        print(self.picker.frame.height)
    }

    @IBAction func jumpNext(_ sender: Any) {
        switch vcList[which] {
        case "AutoresizingVC":
            show(AutoresizingVC(),sender: nil)
        case "DrawClearRectVC":
            show(DrawClearRectVC(),sender: nil)
        case "LayerHierarchyVC":
            show(LayerHierarchyVC(),sender: nil)
        default:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: vcList[which])
            present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func unwindToMainVC(_ segue: UIStoryboardSegue) {}
}



extension Main_UIView: UIPickerViewDelegate, UIPickerViewDataSource {

    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(vcList.count)
        return vcList.count
    }

    // TODO: run it!
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1) Stage" + ( row > 0 ? "s" : "")
    }

    // bug: no views are reused
    // the labels are not leaking (they are deallocated in good order)...
    // but they are not being reused either

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        let lab : UILabel
        if let label = view as? UILabel {
            lab = label
            print("reusing label")
        } else {
            lab = MyLabel()
            print("making new label")
        }
        lab.text = self.vcList[row]
        lab.backgroundColor = .clear
        lab.sizeToFit()
        return lab
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow: Int, inComponent: Int) {
        which = didSelectRow
        jumpNext("")
    }

}

class MyLabel : UILabel {
    deinit {
        print("farewell")
    }
}
