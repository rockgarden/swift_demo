//
//  BaseVC.swift
//  UIViewDemo
//
//  Created by wangkan on 2017/7/1.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class AppBaseVC: UIViewController {

    override func viewDidLoad() {
        view.backgroundColor = .white
        addCloseButton()
    }

    func addCloseButton() {
        let cB = UIButton(type: .roundedRect)
        cB.setTitle("Close", for: .normal)
        cB.addTarget(self, action: #selector(close), for: .touchUpInside)
        cB.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cB)
        NSLayoutConstraint.activate([
            cB.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cB.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            cB.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -40)
            ])
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
