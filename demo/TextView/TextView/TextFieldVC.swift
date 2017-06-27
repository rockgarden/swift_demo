//
//  TextFieldVC.swift
//  TextView
//

import UIKit

class TextFieldVC: UIViewController {

    @IBOutlet var tf : UITextField!
    @IBOutlet var tfDelegate : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        tf.allowsEditingTextAttributes = true
        setupInputAssistantItem(which: 2)

        let mi = UIMenuItem(title:"Expand", action:#selector(MyTextField.expand))
        let mc = UIMenuController.shared
        mc.menuItems = [mi]
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("here '\(string)'")

        if string == "\n" {
            return true // otherwise, our automatic keyboard dismissal trick won't work
        }

        // force user to type in red, underlined, lowercase only

        let lc = string.lowercased()
        textField.text = (textField.text! as NSString)
            .replacingCharacters(in:range, with:lc)

        // not very satisfactory but it does show the result

        let md = (textField.typingAttributes! as NSDictionary).mutableCopy() as! NSMutableDictionary
        let d : [String:Any] = [
            NSForegroundColorAttributeName:
                UIColor.red,
            NSUnderlineStyleAttributeName:
                NSUnderlineStyle.styleSingle.rawValue
        ]
        md.addEntries(from:d)
        textField.typingAttributes = md.copy() as? [String:Any]

        return false
    }

}


//MARK: inputAssistantItem just for ipad
extension TextFieldVC {

    func setupInputAssistantItem(which: Int) {
        switch which {
        case 1:
            let bbi = UIBarButtonItem(
                barButtonSystemItem: .camera, target: self, action: #selector(doCamera))
            let group = UIBarButtonItemGroup(
                barButtonItems: [bbi], representativeItem: nil)
            /// 配置键盘快捷键时使用的输入助手。
            /// 在iPad上，键盘上方的快捷键栏包含用于管理文本的打字建议和其他控件，例如剪切，复制和粘贴命令。 此属性包含用于配置要包含在快捷方式栏中的自定义栏按钮项目的文本输入辅助项目。 iPhone或iPod Touch上的快捷键栏不可用。
            let shortcuts = tf.inputAssistantItem
            shortcuts.trailingBarButtonGroups.append(group)

        case 2:
            var bbis = [UIBarButtonItem]()
            for _ in 1...5 {
                let bbi = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(doCamera))
                bbis.append(bbi)
            }
            let rep = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
            let group = UIBarButtonItemGroup(barButtonItems: bbis, representativeItem: rep)
            let shortcuts = tf.inputAssistantItem
            shortcuts.trailingBarButtonGroups.append(group)

        default:break
        }
    }

    func doCamera(_ sender: Any) {
        print("do camera")
    }

}


//MARK: TextFieldDelegate just for ipad
extension TextFieldVC: UITextFieldDelegate {
    // this way works fine too
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let p = UIPickerView()
        p.delegate = self
        p.dataSource = self

        // tfDelegate.inputView = p

        // 自定义UIInputView
        let iv = UIInputView(frame: CGRect(origin:.zero, size:CGSize(200,200)), inputViewStyle: .keyboard)
        iv.addSubview(p)
        p.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            p.leadingAnchor.constraint(equalTo: iv.leadingAnchor),
            p.trailingAnchor.constraint(equalTo: iv.trailingAnchor),
            p.centerYAnchor.constraint(equalTo: iv.centerYAnchor)
            ])
        tfDelegate.inputView = iv

        let b = UIButton(type: .system)
        b.setTitle("Done", for: .normal)
        b.sizeToFit()
        b.addTarget(self, action: #selector(doDone), for: .touchUpInside)
        b.backgroundColor = UIColor.lightGray
        tfDelegate.inputAccessoryView = b
    }

    func doDone() {
        self.tf.resignFirstResponder()
    }
}


extension TextFieldVC : UIPickerViewDelegate, UIPickerViewDataSource {
    var pep : [String] {return ["Manny", "Moe", "Jack"]}
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pep.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pep[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfDelegate.text = self.pep[row]
    }
    
}

