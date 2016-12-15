//
//  DrawShapesVC.swift
//  Draw
//

import UIKit

class DrawShapesVC: UIViewController {
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        let myView = ShapeView(frame: CGRect(x: 25, y: 200, width: 280, height: 250), shape: sender.tag)
        myView.backgroundColor = UIColor.cyan
        view.addSubview(myView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
