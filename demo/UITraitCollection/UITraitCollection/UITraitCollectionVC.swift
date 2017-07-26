//
//  ViewController.swift
//  UITraitCollection
//
//  Created by wangkan on 16/9/8.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class UITraitCollectionVC: UIViewController, UINavigationControllerDelegate {

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return super.supportedInterfaceOrientations
        //return .landscape
    }

    //    @nonobjc func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController!) -> Int {
    //        return Int(UIInterfaceOrientationMask.landscape.rawValue)
    //    }

    /// simple example of lying to a child view controller about its trait environment
    /// notice that the embedded version of ViewController2 is missing the Dismiss button!
    /// that's because it thinks it has a Compact horizontal size class, which is configured with a different interface in the storyboard
    /// Constraint referencing items turned off in current configuration. Turn off this constraint in the current configuration. item need install wR, item's Constraint also install wR
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController.delegate = self
        print("viewDidLoad")
        print("viewDidLoad reports \(self.view.bounds.size)")
        print("viewDidLoad reports \(self.traitCollection)")
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CompactHorizontalVC")
        self.addChildViewController(vc) // "will" called for us
        //let tc = UITraitCollection(horizontalSizeClass: .Compact)
        let tc = UITraitCollection(displayScale: 0.4)
        self.setOverrideTraitCollection(tc, forChildViewController: vc)
        vc.view.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)

        switch which {
        case 0:
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .black
            view.addSubview(v)
            self.blackSquare = v
            NSLayoutConstraint.activate([
                v.widthAnchor.constraint(equalToConstant: 10),
                v.heightAnchor.constraint(equalToConstant: 10),
                v.topAnchor.constraint(equalTo: view.topAnchor),
                v.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
        default:break
        }

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear \(self.view.bounds.size)")
    }

    // MARK: Assistive Layout
    /// a fresh look at the problem of helping with layout in code
    /// first problem: we don't necessarily get "willTransition" messages on launch
    /// so if there is a view that must be placed into the interface, that(willTransition) isn't where to do it
    /// what we _know_ we'll get at launch is "transitionDidChange" and "viewWillLayout"
    weak var blackSquare : UIView?
    override func viewWillLayoutSubviews() {
        print("willLayout  \(self.view.bounds.size)")
        if self.blackSquare == nil { // both reference and flag
            let v = UIView(frame:CGRect(0,0,10,10))
            v.backgroundColor = .black
            v.center = CGPoint(view.bounds.width/2,5)
            view.addSubview(v)
            self.blackSquare = v
        }
    }

    override func viewDidLayoutSubviews() {
        print("didLayout \(self.view.bounds.size)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear \(self.view.bounds.size)")
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition trait", newCollection)
        super.willTransition(to: newCollection, with: coordinator)
    }

    let which = 2
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("willTransition size", size)
        super.viewWillTransition(to:size, with:coordinator)
        if size != self.view.bounds.size {
            switch which {
            case 1: // too early
                self.blackSquare?.center = CGPoint(size.width/2,5)
            case 2: // too late
                coordinator.animate(alongsideTransition: nil) { _ in
                    self.blackSquare?.center = CGPoint(size.width/2,5)
                }
            case 3: // just right
                coordinator.animate(alongsideTransition:{ _ in
                    self.blackSquare?.center = CGPoint(size.width/2,5)
                })
            default:break
            }
        }
        else { print("nothing to do") }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("trait collection did change to \(self.traitCollection)")
    }

}


/*

 === normal launch into portrait:

 viewDidLoad, portrait view, portrait trait collection
 (will appear)
 trait collection did change
 (willLayout)
 (didLayout)
 (did appear)

 === normal launch with device at landscape: NB this happens regardless of order in info plist!
 [basically the rule seems to be if app can launch into portrait, it will]

 viewDidLoad, portrait view, portrait trait collection
 trait collection did change (and the others)
 [visible rotation]
 will transition to landscape
 will transition to landscape view size
 trait collection did change
 did/will layout

 === app accepts only landscape:

 viewDidLoad, landscape view, landscape trait collection
 (will appear)
 trait collection did change (and the others)
 => so, in this case, we do not start with portrait and then rotate!

 === app accepts any, but landscape is first, but device is held in portrait:
 [New: just like the first case! we launch into portrait and stay there]

 === app accepts any, portrait or landscape is first (!), but view controller is landscape only, device is held in portrait or landscape:

 viewDidLoad, portrait view, portrait trait
 (will appear)
 will transition to landscape trait collection
 NO SIZE CHANGE NOTIFICATION
 trait collection did change
 (layout, did appear)
 [and if the app then rotates 180 degrees]
 will transition to same landscape size

 */

/*
 If we are in, say, navigation interface, we do not have actual view dimensions until "will appear"
 */

/*
 In navigation interface, we can get did layout more than once on rotation... and dimensions are not necessarily correct the first time layout on rotation in that case is *after* the transitions/trait changes
 */

/*
 I took out the navigation interface because it confuses the matter for now; for example, we can launch into portrait even if the navigation controller delegate says no
 */

