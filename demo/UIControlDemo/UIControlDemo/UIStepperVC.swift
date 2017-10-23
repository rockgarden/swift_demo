//
//  UIStepperVC.swift
//  UIControlDemo
//

import UIKit

class UIStepperVC: UIViewController {

    @IBOutlet var stepper : UIStepper!
    @IBOutlet var prog : UIProgressView!

    @IBAction func doStep(_ sender: Any!) {
        let step = sender as! UIStepper
        self.prog.setProgress(Float(step.value / (step.maximumValue - step.minimumValue)), animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.stepper.tintColor = UIColor.yellow

        let imdis = UIImage(named: "pic2.png")!
            .resizableImage(withCapInsets:
                UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.stretch)
        self.stepper.setBackgroundImage(imdis, for:.disabled)

        let imnorm = UIImage(named: "pic1.png")!
            .resizableImage(withCapInsets:
                UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.stretch)
        self.stepper.setBackgroundImage(imnorm, for:.normal)

        let tint = imageOfSize(CGSize(3,3)) {
            self.stepper.tintColor.setFill()
            UIGraphicsGetCurrentContext()!.fill(CGRect(0,0,3,3))
            }.resizableImage(withCapInsets:
                UIEdgeInsetsMake(1, 1, 1, 1), resizingMode:.stretch)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.normal, rightSegmentState:.normal)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.highlighted, rightSegmentState:.normal)
        self.stepper.setDividerImage(tint, forLeftSegmentState:.normal, rightSegmentState:.highlighted)

        // image (treated as template by default)

        let imleft = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSAttributedStringKey.font: UIFont(name:"GillSans-Bold", size:30)!,
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setDecrementImage(imleft, for:.normal)

        let imleftblack = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSAttributedStringKey.font: UIFont(name:"GillSans-Bold", size:30)!,
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setDecrementImage(imleftblack, for:.disabled)

        let imlefttint = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DA}", attributes:[
                NSAttributedStringKey.font: UIFont(name:"GillSans-Bold", size:30)!,
                NSAttributedStringKey.foregroundColor: self.stepper.tintColor,
                NSAttributedStringKey.paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setDecrementImage(imlefttint, for:.highlighted)

        let imright = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSAttributedStringKey.font: UIFont(name:"GillSans-Bold", size:30)!,
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setIncrementImage(imright, for:.normal)

        let imrightblack = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSAttributedStringKey.font: UIFont(name:"GillSans-Bold", size:30)!,
                NSAttributedStringKey.foregroundColor: UIColor.black,
                NSAttributedStringKey.paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setIncrementImage(imrightblack, for:.disabled)

        let imrighttint = imageOfSize(CGSize(45,29)) {
            NSAttributedString(string:"\u{21DB}", attributes:[
                NSAttributedStringKey.font: UIFont(name:"GillSans-Bold", size:30)!,
                NSAttributedStringKey.foregroundColor: self.stepper.tintColor,
                NSAttributedStringKey.paragraphStyle: lend {
                    (para : NSMutableParagraphStyle) in
                    para.alignment = .center
                }
                ]).draw(in:CGRect(0,-5,45,29))
            }.withRenderingMode(.alwaysOriginal)
        self.stepper.setIncrementImage(imrighttint, for:.highlighted)
        //test()
        return
        
    }

    /// interesting effect: remove overlay entirely if disabled
    fileprivate func test() {
        let emptyim = imageOfSize(CGSize(45,29)) {}
        //UIGraphicsBeginImageContextWithOptions(CGSize(45,29), false, 0)
        //let emptyim = UIGraphicsGetImageFromCurrentImageContext()!
        //UIGraphicsEndImageContext();
        self.stepper.setDecrementImage(emptyim, for:.disabled)
        self.stepper.setIncrementImage(emptyim, for:.disabled)
    }

}
