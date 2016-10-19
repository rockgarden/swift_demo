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
        regularView?.frame = CGRect(x: 0, y: 0, width: 700, height: 100)
        let compactView = compactViewController.view
        compactView?.frame = CGRect(x: 300, y: 100, width: 100, height: 500)
        self.view.addSubview(compactView!) //或add compactView
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
        contentView.stackView.axis = traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.regular ? UILayoutConstraintAxis.horizontal : UILayoutConstraintAxis.vertical
        print(traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.regular)
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
        
        let redView = makeView(.red)
        let blueView = makeView(.blue)
        let yellowView = makeView(.yellow)
        
        stackView = UIStackView(arrangedSubviews: [redView, blueView, yellowView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
