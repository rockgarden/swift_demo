

import UIKit

/// 定义传值闭包: 传递的参数 UIImage
typealias ImageClosure = (_ im: UIImage) ->Void

//FIXME: back UIImagePickerController can't run
class SecondViewController: UIViewController {

    var image : UIImage!
    @IBOutlet var iv : UIImageView!
    var sendClosure: ImageClosure?

    init(image im:UIImage!) {
        self.image = im
        super.init(nibName: "SecondViewController", bundle: nil)
        self.title = "Decide"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Use", style: .plain, target: self, action: #selector(doUse))
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.iv.image = self.image
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func doUse(_ sender: Any) {
        /// 创建闭包方法
        if sendClosure != nil {
            sendClosure!(self.image) //保存回传值的闭包
        }

        self.dismiss(animated: true)
        
        /// Error: 由于引入了 UINavigationController 所以 presentingViewController 不是 ViewController
        //let vc = self.presentingViewController as! ViewController
        //vc.doUse(self.image)
    }
}
