//
//  ZoomOutVC.swift
//  UIViewController
//
//  Created by wangkan on 2017/7/8.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class ZoomOutVC: UIViewController {

    lazy var tb: UIButton = UIButton().with {
        //$0.spinnerColor = .white
        $0.frame = CGRect(90, 90, 60, 40)
        $0.backgroundColor = .red
        $0.setTitle("close", for: UIControlState())
        $0.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        $0.addTarget(self, action: #selector(onTapScreen), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(tb)

        modalPresentationStyle = .custom
        transitioningDelegate = self

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapScreen))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapRecognizer)
    }

    func onTapScreen() {
        dismiss(animated: true, completion: nil)
    }
}

extension ZoomOutVC: UIViewControllerTransitioningDelegate {


//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return nil
//    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ZoomOutTransition(originFrame: tb.frame)
    }
}
