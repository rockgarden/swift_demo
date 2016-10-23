//
//  ViewController.swift
//  Delegate_Protocol
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController, myDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var principalLabel: UILabel!
    
    @IBAction func mainButton(_ sender: UIButton) {
        // we got it the final instance in storyboard
        let secondController: SecondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        secondController.data = "Text from superclass"
        // who is it delegate
        secondController.delegate = self
        // we do push to navigate
        self.navigationController?.pushViewController(secondController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self // delegation
    }
    
    func navigationControllerSupportedInterfaceOrientations(
        _ nav: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func doButton(_ sender: AnyObject) {
        self.showColorPicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func writeDateInLabel(_ data: NSString) {
        self.principalLabel.text = data as String
    }
    
}

extension ViewController: ColorPickerDelegate {
    
    func showColorPicker() {
        let colorName = "MyColor"
        let c = UIColor.blue
        let cpc = ColorPickerController(colorName: colorName, andColor: c)
        cpc.delegate = self
        self.present(cpc, animated: true, completion: nil)
    }
    
    // delegate method
    func colorPicker (_ picker: ColorPickerController,
                      didSetColorNamed theName: String?,
                                       toColor theColor: UIColor?) {
        print("the delegate method was called")
        delay(0.1) {
            self.view.backgroundColor = theColor
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}

