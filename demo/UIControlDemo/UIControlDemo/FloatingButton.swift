//
//  FloatingButton.swift
//
//  Created by Carlos Martin (SE) on 05/12/2016.
//  Copyright © 2016 Carlos Martín. All rights reserved.
//

import Foundation
import UIKit

class FloatingButton {
    private var button: UIButton
    private var overlayView: UIView
    
    init(controller: UINavigationController, target: Any?, action: Selector) {
        let screenSize: CGRect = UIScreen.main.bounds
        let frame = CGRect(x: screenSize.width-75,
                           y: screenSize.height-120,
                           width: 50,
                           height: 50)
        self.overlayView = UIView(frame: frame)
        self.overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.button = UIButton(type: UIButtonType.system) as UIButton
        self.button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.button.backgroundColor = UIColor.groupTableViewBackground
        self.button.tintColor = UIColor.black
        
        self.button.layer.cornerRadius = 25
        self.button.layer.shadowColor = UIColor.gray.cgColor
        self.button.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.button.layer.shadowOpacity = 1.0
        self.button.layer.shadowRadius = 0.0
        
        self.button.setImage(UIImage(named: "write"), for: .normal)
        self.button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        self.overlayView.addSubview(self.button)
        controller.view.addSubview(overlayView)
    }
    
    func delete(view: UIView) {
        self.animateDown(view: view)
        self.button.removeFromSuperview()
    }
    
    func animateDown (view: UIView) {
        let duration = 0.5
        let curve: UInt = 1
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: UIViewAnimationOptions(rawValue: curve),
            animations: {
                self.overlayView.bounds = CGRect(
                    x: 0,
                    y: -150,
                    width: 50,
                    height: 50
                )
                view.layoutIfNeeded()},
            completion: nil
        )
    }
    
    func animateUp (view: UIView) {
        let duration = 0.5
        let curve: UInt = 1
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: UIViewAnimationOptions(rawValue: curve),
            animations: {
                self.overlayView.bounds = CGRect(
                    x: 0,
                    y: 0,
                    width: 50,
                    height: 50
                )
                view.layoutIfNeeded()},
            completion: nil
        )
    }
}
