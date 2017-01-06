//
//  ButtonVC.swift
//  UIControlDemo
//

import UIKit

class ButtonVC: UIViewController {
    
    @IBOutlet weak var roundButton: RoundButton!
    @IBOutlet weak var roundBorderedbutton: RoundBorderedButton!
    @IBOutlet weak var fpButton: FPButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Round Button", message: "You clicked the button.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedButton(sender: RoundBorderedButton) {
        roundBorderedbutton.isSelected = !roundBorderedbutton.isSelected
    }
    
    @IBAction func tapButton(sender: Any) {
        fpButton.isSelected = !fpButton.isSelected
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


//
//  RoundButton.swift
//

import UIKit

public class RoundButton: UIButton {
    
    var borderColor: UIColor = UIColor.red {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
    }
}


//
//  FPButton.swift
//
import UIKit
//FIXME: isSelected 样式异常
public class FPButton: UIButton {
    
    // MARK: Properties
    
    var isAlwaysChecked : Bool = false {
        didSet {
            if isAlwaysChecked {
                self.checked = true
            }
        }
    }
    
    var checked : Bool = false {
        didSet {
            if checked {
                setTitleColor(UIColor.white, for: .normal)
                layer.borderColor = checkedColor.cgColor
                layer.backgroundColor = checkedColor.cgColor
            } else {
                setColor(color: uncheckedColor)
                layer.backgroundColor = UIColor.clear.cgColor
            }
        }
    }
    @IBInspectable var cornerRadius : CGFloat = 5 {
        didSet {
            layer.cornerRadius = 5
        }
    }
    @IBInspectable var borderWidth : CGFloat = 2 {
        didSet {
            layer.borderWidth = 2
        }
    }
    @IBInspectable var checkedColor : UIColor = UIColor.clear {
        didSet {
            if checked {
                setColor(color: checkedColor)
            }
        }
    }
    @IBInspectable var uncheckedColor : UIColor = UIColor.clear {
        didSet {
            if !checked {
                setColor(color: uncheckedColor)
            }
        }
    }
    
    // MARK: Init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    init() {
        let defaultFrame = CGRect(x: 0, y: 0, width: 100, height: 44)
        super.init(frame: defaultFrame)
        _init()
    }
    
    private func _init() {
        setColor(color: UIColor.red)
        layer.borderWidth = self.borderWidth
        layer.cornerRadius = self.cornerRadius
        addTarget(self, action: #selector(FPButton.buttonClicked), for: .touchUpInside)
    }
    
    
    // MARK: Actions
    
    func buttonClicked() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .curveEaseIn, animations: { () in
            self.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        }, completion: { (_) in
            if !self.isAlwaysChecked {
                self.checked = !self.checked
            }
        })
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .curveEaseIn, animations:  { () in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    
    // MARK: Helpers
    
    func setColor(color : UIColor) {
        setTitleColor(color, for: .normal)
        layer.borderColor = color.cgColor
    }
    
}

