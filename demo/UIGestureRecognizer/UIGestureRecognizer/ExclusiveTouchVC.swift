
import UIKit

/// isExclusiveTouch: 布尔值，指示接收机是否专门处理触摸事件。将此属性设置为true会导致接收者在同一窗口中阻止将触摸事件传递给其他视图, 即手指在两个view时将无法识别 pinch 手势。
class ExclusiveTouchVC : UIViewController {
    
    @IBOutlet weak var sw: UISwitch!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func pinch(_ sender: Any?) {
        print("pinch")
    }
    
    @IBAction func switched(_ sender: Any) {
        let sw = sender as! UISwitch
        for v in self.view.subviews {
            if v is MyView || v is UIButton {
                v.isExclusiveTouch = sw.isOn
            }
        }
    }
    
    func ignoreMe() {
        self.sw.setOn(true, animated: true)
        self.sw.sendActions(for:.valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            let r = UIGraphicsImageRenderer(size:CGSize(width:20, height:20))
            let im = r.image { _ in
                UIColor.red.setFill()
                UIBezierPath(rect: CGRect(x: 0, y: 0, width: 20, height: 20)).fill()
            }
            self.sw.onImage = im // 无效
        } else {
            // Fallback on earlier versions
        }
    }

}

class MyView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with e: UIEvent?) {
        print(self)
    }
    
}
