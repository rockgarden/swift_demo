//
//  PanGestureViewDemo.swift
//  PanGestureView
//
//  Created by Arvindh Sukumar on 30/01/16.
//  Copyright © 2016 Arvindh Sukumar. All rights reserved.
//

import UIKit

class PanGestureViewDemo: UIViewController {
    /// var 前面加上了 weak，弱引用变量在没有被强引用的条件下会变成nil
    var swipeView: PanGestureView!
    var label: UILabel!

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        /// swipeView 必须在 viewDidLoad 中完成
        swipeView = PanGestureView(frame: view.frame)
        view.addSubview(swipeView)
        setupViews()
        setupActions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setupActions(){
        
        let action = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.right, image: UIImage(named: "chevron-left")!)
        action.backgroundColor = UIColor(red:0.25, green:0.74, blue:0.55, alpha:1)
        action.didTriggerBlock = {
            direction in
            
            self.actionDidTrigger(action)
        }
        swipeView.addAction(action)
        
        let action2 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.left, image: UIImage(named: "chevron-right")!)
        action2.backgroundColor = UIColor(red:0.31, green:0.59, blue:0.7, alpha:1)
        action2.didTriggerBlock = {
            direction in
            
            self.actionDidTrigger(action2)
            
        }
        swipeView.addAction(action2)
        
        let action3 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.up, image: UIImage(named: "chevron-down")!)
        action3.backgroundColor = UIColor(red:0.57, green:0.56, blue:0.95, alpha:1)
        action3.didTriggerBlock = {
            direction in
            
            self.actionDidTrigger(action3)
            
        }
        
        swipeView.addAction(action3)
        
        let action4 = PanGestureAction(swipeDirection: PanGestureViewSwipeDirection.down, image: UIImage(named: "chevron-up")!)
        action4.backgroundColor = UIColor(red:0.96, green:0.7, blue:0.31, alpha:1)
        action4.didTriggerBlock = {
            direction in
            
            self.actionDidTrigger(action4)
            
        }
        swipeView.addAction(action4)
    }
    
    fileprivate func setupViews(){

        let container = UIView(frame: CGRect(x: 0,y: 0,width: 200,height: 200))
        container.backgroundColor = UIColor(white: 0.9, alpha: 1)
        container.layer.cornerRadius = 100
        container.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        
        label = UILabel(frame: CGRect(x: 0,y: 0,width: 140,height: 30))
        label.text = "Pan Anywhere"
        label.textAlignment = NSTextAlignment.center
        label.center = container.center
        
        container.addSubview(label)
        
        swipeView.contentView.addSubview(container)
        container.center = swipeView.contentView.center
        
    }
    
    fileprivate func actionDidTrigger(_ action: PanGestureAction){
        
        let container = self.label.superview!
        
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            
            container.backgroundColor = action.backgroundColor
            self.label.text = "Panned \(action.swipeDirection)"
            self.label.textColor = UIColor.white

        }) 
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}

