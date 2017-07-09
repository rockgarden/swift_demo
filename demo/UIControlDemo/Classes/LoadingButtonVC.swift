//
//  ViewController.swift
//  MMLoadingButton
//
//  Created by Millman on 09/04/2016.
//  Copyright (c) 2016 Millman. All rights reserved.
//

import UIKit

class LoadingButtonVC: UIViewController{
    @IBOutlet weak var txtAccount:UITextField!
    @IBOutlet weak var txtPwd:UITextField!
    @IBOutlet weak var loadingBtn:LoadingButton!
    
    @IBAction func loadAction () {
        loadingBtn.startLoading()

        if let vc = UIStoryboard.init(name: "LoadingButton", bundle: nil).instantiateViewController(withIdentifier: "Second") as? LoadingButtonVC2 {
            self.loadingBtn.addScuessPresentVC(vc)
        }
        self.fakeResult()
    }
    
    func fakeResult() {
        
        let delayTime = DispatchTime.now() + .seconds(2)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if !self.txtAccount.text!.isEmpty && !self.txtPwd.text!.isEmpty {
                self.loadingBtn.stopLoading(true, completed: {
                    print("Scuess Completed")
                })
            } else if self.txtAccount.text!.isEmpty {
                self.loadingBtn.stopWithError("Account is Empty!!", hideInternal: 2, completed: {
                    print ("Fail Message Completed")
                })
                
            } else{
                self.loadingBtn.stopWithError("Password is Empty!!", hideInternal: 2, completed: {
                    print ("Fail Message Completed")
                })
                
            }

        }
    }
}


class LoadingButtonVC2: UIViewController {
    @IBOutlet weak var scuess:LoadingButton!
    @IBOutlet weak var error:LoadingButton!
    @IBOutlet weak var errMsg:LoadingButton!

    @IBAction func scuessAction() {
        scuess.startLoading()

        let delayTime = DispatchTime.now() + .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.scuess.stopLoading(true, completed: {
                print("Scuess Completed")
            })
        }
    }

    @IBAction func errorAction() {
        error.startLoading()

        let delayTime = DispatchTime.now() + .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.error.stopLoading(false, completed: {
                print("Fail Completed")
            })
        }
    }

    @IBAction func errorMsgAction() {
        errMsg.startLoading()

        let delayTime = DispatchTime.now() + .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.errMsg.stopWithError("Error !!", hideInternal: 2, completed: {
                print ("Fail Message Completed")
            })
        }
    }


    @IBAction func presentAction () {

        if let vc = UIStoryboard.init(name: "LoadingButton", bundle: nil).instantiateViewController(withIdentifier: "Thrid") as? LoadingButtonVC3 {
            self.present(vc, animated: true, completion: nil)
        }

    }

    @IBAction func dismissAction () {
        self.dismiss(animated: true, completion: nil)
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


class LoadingButtonVC3: UIViewController {

    @IBOutlet weak var scuess:LoadingButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        scuess.addScuessWithDismissVC()
    }

    @IBAction func dismissAction () {
        scuess.startLoading()
        let delayTime = DispatchTime.now() + .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.scuess.stopLoading(true, completed: {
                print("Scuess Completed")
            })
        }
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

