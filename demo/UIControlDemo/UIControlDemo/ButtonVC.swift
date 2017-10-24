//
//  ButtonVC.swift
//  UIControlDemo
//

import UIKit

class ButtonVC: UIViewController {
    
    @IBOutlet weak var roundButton: RoundButton!
    @IBOutlet weak var roundBorderedbutton: RoundBorderedButton!
    @IBOutlet weak var fpButton: FPButton!
    @IBOutlet weak var tsButton: TransitionSubmitButton!
    @IBOutlet weak var activityButton: ActivityButton!
    @IBOutlet weak var cpButton: CircleRippleButton!
    //@IBOutlet weak var submitB: SubmitButton!

    @IBOutlet var actBtn1: ActivityUIButton!
    @IBOutlet var actBtn2: ActivityUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let submitB = SubmitButton(frame: CGRect(x: 80, y: 40, width: 160, height: 54))
        submitB.addTarget(target: self, action: #selector(demoFunction))
        submitB.submitImage = UIImage(named: "jack");
        submitB.successImage = UIImage(named: "knob");
        submitB.warningImage = UIImage(named: "manny")
        delay(3.0) {
            submitB.buttonState = .success
        }
        //view.addSubview(submitB)
        
        //tsButton = TransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 64, height: 44))
        //tsButton.center = self.view.center
        //tsButton.frame.bottom = self.view.frame.height - 60
        tsButton.spinnerColor = .white
        tsButton.backgroundColor = .red
        tsButton.setTitle("Sign in", for: UIControlState())
        tsButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        tsButton.addTarget(self, action: #selector(onTapActivityButton), for: .touchUpInside)
        
//        let middleMain: CGFloat = self.view.bounds.size.width / 2
//        var middleButton: CGFloat = 100.0 / 2

        //activityButton = ActivityButton(frame: CGRect(x: middleMain - middleButton, y: 60, width: 100, height: 100))
        activityButton.backgroundColor = UIColor.blue
        activityButton.titleLabel.text = "Process"
        activityButton.activityTitle = "Processing"
        activityButton.rotatorColor = UIColor.black
        activityButton.rotatorSize = 12.0
        activityButton.rotatorSpeed = 8.0
        
//        activityButton2 = ActivityButton(frame: CGRect(x: middleMain - middleButton, y: 227, width: 76, height: 76))
//        activityButton2.backgroundColor = UIColor.orange
//        activityButton2.titleLabel.text = "Load"
//        activityButton2.activityTitle = "Loading"
//        activityButton2.rotatorColor = UIColor.darkGray
//        activityButton2.rotatorSize = 12.0
//        activityButton2.rotatorSpeed = 8.0
//        activityButton2.rotatorPadding = 15.0
//        view.addSubview(activityButton2)
//        
//        middleButton = 150.0 / 2
//        
//        activityButton3 = ActivityButton(frame: CGRect(x: middleMain - middleButton, y: 375, width: 150, height: 150))
//        activityButton3.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
//        activityButton3.titleLabel.text = "Download";
//        activityButton3.activityTitle = "Downloading"
//        activityButton3.rotatorColor = UIColor.blue
//        activityButton3.rotatorSize = 16.0
//        activityButton3.rotatorSpeed = 8.0
//        activityButton3.rotatorPadding = -7.0
//        view.addSubview(activityButton3)


        //Mark: Buttons From Nib
        // Configure State
        let disabledColor = UIColor(white: 0.673, alpha: 1.0)

        actBtn1.hideTextWhenLoading = false
        actBtn1.isLoading = false
        actBtn1.activityIndicatorAlignment = .right
        actBtn1.activityIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 10)
        actBtn1.setTitleColor(disabledColor, for: .disabled)

        // create the attributed string
        let attributedString = NSMutableAttributedString(
            string: "connecting",
            attributes: [
                NSAttributedStringKey.foregroundColor : disabledColor,
                ]
        )
        actBtn1.setAttributedTitle(attributedString, for: .disabled)
        //        btn1.activityIndicatorColor = .blue

        actBtn2.hideTextWhenLoading = false
        actBtn2.isLoading = false
        actBtn2.activityIndicatorAlignment = .left
        actBtn2.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        actBtn2.activityIndicatorEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        actBtn2.setTitle("Loading", for: .disabled)
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
    
    @objc func onTapActivityButton(_ button: TransitionSubmitButton) {
        button.animate(1, completion: { () -> () in
            let vc = FadeInAnimatorVC()
            vc.transitioningDelegate = self
            self.present(vc, animated: true, completion: nil)
        })
    }
    
    @IBAction func runCircleRipple(_ sender: Any) {
        cpButton.startAction()
        let vc = UIStoryboard.init(name: "LoadingButton", bundle: nil).instantiateViewController(withIdentifier: "LoadingButtonVC") as? LoadingButtonVC
        self.present(vc!, animated: true) {
            GCD.delay(3) { () -> () in
                self.cpButton.stopAction(true)
            }
        }
    }

    @objc func demoFunction() {
        print("Demo");
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activityButton.stopActivity()
    }

    func randomAttributes(button: ActivityUIButton) {
        buttonTapAction(button)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // your function here
            self.randomAttributes(button: button)
        }
    }

    @IBAction func buttonTapAction(_ button:ActivityUIButton) {
        button.isLoading = !button.isLoading
        button.activityIndicatorAlignment = .center
        button.hideImageWhenLoading = true
    }

    @IBAction func doTap(_ sender:ActivityUIButton) {
        sender.isEnabled = false
        sender.isLoading = true;

        if sender.tag == 3 {
            sender.hideImageWhenLoading = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            sender.isEnabled = true
            sender.isLoading = false

            if sender.tag == 3 {
                sender.isSelected = !sender.isSelected
            }
        }

    }
    
}

extension ButtonVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        ta.originFrame = tsButton.convert(tsButton.frame, to: nil)
//        ta.presenting = true
//        tsButton.isHidden = true
//        return nil
        return FadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.0)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        tsButton.isHidden = false
//        ta.presenting = false
//        return ta
        return nil
    }
}


///  RoundButton.swift
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


///  FPButton.swift
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
    @objc func buttonClicked() {
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

