//
//  RippleVC.swift
//  RippleEffectDemo
//
//  Created by Alex Sergeev on 8/21/16.
//  Copyright © 2016 ALSEDI Group. All rights reserved.
//


import UIKit

extension UIColor {
    static var random: UIColor {
        get {
            let hue = CGFloat(Double(arc4random() % 360) / 360.0) // 0.0 to 1.0
            let saturation: CGFloat = 0.7
            let brightness: CGFloat = 0.8
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }
    }
}

class RippleVC: UIViewController {
    var rippleEffectView: RippleEffectView!

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        rippleEffectView = RippleEffectView()
        rippleEffectView.tileImage = UIImage(named: "cell-image")
        rippleEffectView.magnitude = 0.2
        rippleEffectView.cellSize = CGSize(width:50, height:50)
        rippleEffectView.rippleType = .heartbeat
        view.addSubview(rippleEffectView)

        //Example, simple tile image customization
        /*
         rippleEffectView.tileImageCustomizationClosure = {rows, columns, row, column, image in
         if (row % 2 == 0 && column % 2 == 0) {
         let newImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
         UIGraphicsBeginImageContextWithOptions(image.size, false, newImage.scale)
         UIColor.random.set()
         newImage.drawInRect(CGRectMake(0, 0, image.size.width, newImage.size.height));
         if let titledImage = UIGraphicsGetImageFromCurrentImageContext() {
         UIGraphicsEndImageContext()
         return titledImage
         }
         UIGraphicsEndImageContext()
         }
         return image
         }
         */

        //Example 2: Complex tile image customization
        rippleEffectView.tileImageCustomizationClosure = { rows, columns, row, column, image in
            let newImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(image.size, false, newImage.scale)

            let xmiddle = (columns % 2 != 0) ? columns/2 : columns/2 + 1
            let ymiddle = (rows % 2 != 0) ? rows/2 : rows/2 + 1

            let xoffset = abs(xmiddle - column)
            let yoffset = abs(ymiddle - row)

            UIColor(hue: 206/360.0, saturation: 1, brightness: 0.95, alpha: 1).withAlphaComponent(1.0 - CGFloat((xoffset + yoffset)) * 0.1).set()

            newImage.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: newImage.size.height));
            if let titledImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return titledImage
            }
            UIGraphicsEndImageContext()
            return image
        }



        rippleEffectView.setupView()
        rippleEffectView.animationDidStop = { [unowned self] in
            //Each time animation sequency finished this callback will change background of the wrapper view.
            //FIXME: 返回时报错
            UIView.animate(withDuration: 1.5, animations: { _ in
                self.rippleEffectView.backgroundColor = UIColor.random.withAlphaComponent(0.25)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rippleEffectView.startAnimating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        rippleEffectView.stopAnimating()
    }
}

