
import UIKit

class PositionResizableImageVC: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    let which = 1
    let which1 = 2
    var v: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.iv.image = self.iv.image?.imageFlippedForRightToLeftLayoutDirection()

        let mainview = self.view

        let iv1 = UIImageView(image: UIImage(named:"Mars")) // asset catalog
        mainview?.addSubview(iv1)
        let mars = UIImage(named:"Mars")!
        var marsTiled = UIImage()

        iv1.clipsToBounds = true // default is false...
        // though this won't matter unless you also play with the content mode
        iv1.contentMode = .scaleAspectFit // default is .ScaleToFill...
        // ... which fits but doesn't preserve aspect

        //        print(iv.clipsToBounds)
        //        print(iv.contentMode.rawValue)

        // just to clarify boundaries of image view
        iv1.layer.borderColor = UIColor.black.cgColor
        iv1.layer.borderWidth = 2

        switch which {
        case 1:
            // position using autoresizing-type behavior
            iv1.center = iv1.superview!.bounds.center // see above
            iv1.frame = iv1.frame.integral //instead .frame.makeIntegralInPlace
        case 2:
            // position using constraints
            iv1.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iv1.centerXAnchor.constraint(equalTo: iv1.superview!.centerXAnchor),
                iv1.centerYAnchor.constraint(equalTo: iv1.superview!.centerYAnchor)
                ])
        default: break
        }

        // showing what happens when a different image is assigned
        delay (5) {
            iv1.image = UIImage(named:"bottle5")
            // if we're using constraints...
            // the image view is resized, because setting the image changes the intrinsic content size
        }

        switch which1 {
        case 1:
            marsTiled = mars.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .tile)
        case 2:
            marsTiled = mars.resizableImage(
                withCapInsets: UIEdgeInsetsMake(
                    mars.size.height / 4.0,
                    mars.size.width / 4.0,
                    mars.size.height / 4.0,
                    mars.size.width / 4.0
            ), resizingMode: .tile)
        case 3:
            marsTiled = mars.resizableImage(
                withCapInsets: UIEdgeInsetsMake(
                    mars.size.height / 4.0,
                    mars.size.width / 4.0,
                    mars.size.height / 4.0,
                    mars.size.width / 4.0
            ), resizingMode: .stretch)
        case 4:
            marsTiled = mars.resizableImage(
                withCapInsets: UIEdgeInsetsMake(
                    mars.size.height / 2.0 - 1,
                    mars.size.width / 2.0 - 1,
                    mars.size.height / 2.0 - 1,
                    mars.size.width / 2.0 - 1
            ), resizingMode: .stretch)
        default: break
        }

        self.iv2.image = marsTiled

    }

}

