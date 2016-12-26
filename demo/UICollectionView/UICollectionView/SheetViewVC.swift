//
//  ViewController.swift
//  UICollectionView
//
//  Created by wangkan on 2016/10/31.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class SheetViewVC: UIViewController {
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint! {
        didSet {
            bottomViewHeight.constant = FileManagerViewHeight
        }
    }
    @IBOutlet var bottomView: UIView!
    var albumView = MyFileManagerView.instance()

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.addSubview(albumView)
        albumView.delegate  = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        albumView.frame  = CGRect(origin: CGPoint.zero, size: bottomView.frame.size)
        albumView.layoutIfNeeded()
        albumView.initialize()
    }

}


extension SheetViewVC : MyFileManagerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func cameraRollUnauthorized() {
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.canOpenURL(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true //true为拍照、选择完进入图片编辑模式
        imagePickerController.sourceType = .camera
        imagePickerController.modalPresentationStyle = .currentContext
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

