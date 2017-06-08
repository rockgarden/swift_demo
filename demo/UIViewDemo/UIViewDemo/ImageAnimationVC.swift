import UIKit


class ImageAnimationVC : UIViewController {


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .white
        delay(1.0) {self.animate()}
    }

    func animate () {

        do {
            let mars = UIImage(named: "Mars")!
            let empty = imageOfSize(mars.size) { }
            let arr = [mars, empty, mars, empty, mars]
            let iv = UIImageView(image:empty)
            iv.frame.origin = CGPoint(100,100)
            self.view.addSubview(iv)

            iv.animationImages = arr
            iv.animationDuration = 2
            iv.animationRepeatCount = 1
            delay(2) {
                iv.startAnimating()
            }
        }
        do {
            var arr = [UIImage]()
            let w : CGFloat = 18
            for i in 0 ..< 6 {
                let im = imageOfSize(CGSize(w,w)) {
                    let con = UIGraphicsGetCurrentContext()!
                    con.setFillColor(UIColor.red.cgColor)
                    let ii = CGFloat(i)
                    con.addEllipse(in:CGRect(0+ii,0+ii,w-ii*2,w-ii*2))
                    con.fillPath()
                }
                arr += [im]
            }
            let im = UIImage.animatedImage(with:arr, duration:0.5)
            let b = UIButton(type:.system)
            b.setTitle("Howdy", for:.normal)
            b.setImage(im, for:.normal)
            b.center = CGPoint(100,250)
            b.sizeToFit()
            self.view.addSubview(b)
        }
        do {
            let im = UIImage.animatedImageNamed("pac", duration:1)
            let b = UIButton(type:.system)
            b.setImage(im, for:.normal)
            b.center = CGPoint(100,320)
            b.sizeToFit()
            self.view.addSubview(b)
        }
    }

}


