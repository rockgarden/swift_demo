//
//  TransparentBarDemo.swift
//

import UIKit

class TransparentBarDemo: UIViewController, TFTransparentNavigationBarProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - TFTransparentNavigationBarProtocol
    func navigationControllerBarPushStyle() -> TFNavigationBarStyle {
        return .transparent
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
