//
//  SizeClasses.swift
//  UIStackView
//
//  Created by wangkan on 16/9/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class SizeClasses: UIViewController {
    
    let regularViewController = SizeClass()
    let compactViewController = SizeClass()
    
    convenience init(frame: CGRect) {
        self.init(nibName: nil, bundle: nil)
        title = "Size Classes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let regularView = regularViewController.view
        regularView.frame = CGRectMake(0, 0, 700, 100)
        let compactView = compactViewController.view
        compactView.frame = CGRectMake(300, 100, 100, 500)
        self.view.addSubview(compactView) //或add compactView
    }
    
}

class SizeClass : UIViewController {
    
    var contentView: View {
        return view as! View
    }
    
    override func loadView() {
        view = View(frame: .zero)
    }
    
    override func viewDidLayoutSubviews() {
        contentView.stackView.axis = traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular ? UILayoutConstraintAxis.Horizontal : UILayoutConstraintAxis.Vertical
        print(traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular)
    }
}

class View: UIView {
    
    let stackView: UIStackView
    
    override init(frame: CGRect) {
        let makeView = { (color: UIColor) -> UIView in
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = color
            return view
        }
        
        let redView = makeView(.redColor())
        let blueView = makeView(.blueColor())
        let yellowView = makeView(.yellowColor())
        
        stackView = UIStackView(arrangedSubviews: [redView, blueView, yellowView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .FillEqually
        
        super.init(frame: frame)
        backgroundColor = .whiteColor()
        
        addSubview(stackView)
        
        stackView.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 10).active = true
        stackView.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -10).active = true
        stackView.topAnchor.constraintEqualToAnchor(topAnchor, constant: 10).active = true
        stackView.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -10).active = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
