import UIKit


class LayerHierarchyVC : AppBaseVC {
    
    let which = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lay1 = CALayer()
        lay1.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1).cgColor
        lay1.frame = CGRect(113, 111, 132, 194)
        view.layer.addSublayer(lay1)
        let lay2 = CALayer()
        lay2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1).cgColor
        lay2.frame = CGRect(41, 56, 132, 194)
        lay1.addSublayer(lay2)
        
        switch which {
        case 1:
            // 一个视图可以穿插着兄弟姐妹层 a view can be interspersed with sibling layers
            let iv = UIImageView(image:UIImage(named:"smiley"))
            view.addSubview(iv)
            // iv.layer.zPosition = 1
            iv.frame.origin = CGPoint(180,180)
        case 2:
            // a layer can have image content
            let lay4 = CALayer()
            let im = UIImage(named:"smiley")!
            lay4.frame = CGRect(origin:CGPoint(180,180), size:im.size)
            lay4.contents = im.cgImage //Must take the CGImage
            // a UIImage still gets no error but no image
            view.layer.addSublayer(lay4)
        default: break
        }

        let lay3 = CALayer()
        lay3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        lay3.frame = CGRect(43, 197, 160, 230)
        self.view.layer.addSublayer(lay3)
        
//        let iv = UIImageView(image:UIImage(named:"smiley"))
//        self.view.addSubview(iv)
//        iv.frame.origin = CGPoint(180,180)

        lay1.name = "manny"
        lay2.name = "moe"
        lay3.name = "jack"
        delay(2) {
            print(self.view.layer.sublayers?.map{$0.name} as Any)
        }
        
        lay1.setValue("manny", forKey: "pepboy")
        lay2.setValue("moe", forKey: "pepboy")
        lay3.setValue("jack", forKey: "pepboy")
        delay(2) {
            self.view.layer.sublayers?.forEach {
                print($0.value(forKey: "pepboy") as Any)
            }
        }


    }
    
}
