//
//  PopoverPresentingVC.swift
//  UIViewController
//
//  Created by wangkan on 2017/8/15.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import UIKit

class PPVC1: UIViewController {

    @IBAction func doDismiss(_ sender: Any) {
        dismiss(animated:true)
    }
}


class PPVC2: UIViewController, UIPopoverPresentationControllerDelegate {

    // showing how behavior of modalInPopover for presented-inside-popover has changed from iOS 7

    let workaround = true

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pop = self.popoverPresentationController {
            if workaround {
                print("del")
                pop.delegate = self
            }
        }
    }

    func popoverPresentationControllerShouldDismissPopover(_ pop: UIPopoverPresentationController) -> Bool {
        let ok = pop.presentedViewController.presentedViewController == nil
        print(ok)
        return ok
    }
    
}


class PPVC3: UIViewController {

    let workaround = false

    var oldModal = false

    override func viewWillAppear(_ animated: Bool) {
        // okay, this is really weird: you need _both_!
        // note that this works only on iOS 9! no effect on iOS 8
        if workaround {
            if let pres = self.presentingViewController {
                self.isModalInPopover = true
                self.oldModal = pres.isModalInPopover
                pres.isModalInPopover = true
            }
        }
    }

    @IBAction func doDone(_ sender: Any) {
        // and then on dismissal must undo both!
        if workaround {
            if let pres = self.presentingViewController {
                self.isModalInPopover = false
                pres.isModalInPopover = self.oldModal
            }
        }
        self.dismiss(animated:true)
    }
}
