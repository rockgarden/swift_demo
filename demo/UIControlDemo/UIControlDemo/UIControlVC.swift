//
//  ViewController.swift
//  UIControlDemo
//
//  Created by wangkan on 2016/12/28.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class UIControlVC: UIViewController {

    @IBOutlet var knob : MyKnob!
    @IBOutlet weak var shrinkingButton : UIButton!
    @IBOutlet weak var button2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }

    func setupButton() {
        super.viewDidLoad()

        let im = UIImage(named:"coin")!
        let sz = im.size
        let im2 = im.resizableImage(withCapInsets:UIEdgeInsetsMake(
            sz.height/2, sz.width/2, sz.height/2, sz.width/2),
                                    resizingMode: .stretch)
        self.shrinkingButton.setBackgroundImage(im2, for:.normal)
        self.shrinkingButton.backgroundColor = .clear
        self.shrinkingButton.setImage(im2, for:.normal)

        let mas = NSMutableAttributedString(string: "Pay Tribute", attributes: [
            NSFontAttributeName: UIFont(name:"GillSans-Bold", size:16)!,
            NSForegroundColorAttributeName: UIColor.purple,
            // in iOS 8.3 can comment out next line; bug is fixed
            // NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue
            ])
        mas.addAttributes([
            NSStrokeColorAttributeName: UIColor.red,
            NSStrokeWidthAttributeName: -2,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
            ], range: NSMakeRange(4, mas.length-4))
        self.shrinkingButton.setAttributedTitle(mas, for:.normal)

        let mas2 = mas.mutableCopy() as! NSMutableAttributedString
        mas2.addAttributes([
            NSForegroundColorAttributeName: UIColor.white
            ], range: NSMakeRange(0, mas2.length))
        self.shrinkingButton.setAttributedTitle(mas2, for: .highlighted)

        self.shrinkingButton.adjustsImageWhenHighlighted = true

        self.button2.titleLabel!.numberOfLines = 2
        self.button2.titleLabel!.textAlignment = .center
        self.button2.setTitle("Button with a title that wraps", for:.normal)

        let con = UIGraphicsGetCurrentContext()!
        con.addArc(center: <#T##CGPoint#>, radius: <#T##CGFloat#>, startAngle: <#T##CGFloat#>, endAngle: <#T##CGFloat#>, clockwise: <#T##Bool#>) //(in: CGRect(0,0,size.width,size.height))
        //con.setFillColor(UIColor.applicationAlphaLightGray.cgColor)
        //con.fillPath()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doKnob (_ sender: Any!) {
        let knob = sender as! MyKnob
        debugPrint("knob angle is \(knob.angle)")
    }

}

