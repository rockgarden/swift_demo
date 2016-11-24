
import UIKit
import ImageIO
import MobileCoreServices

//// temporary workaround from Joe Groff at Apple
//extension CFString: Hashable {
//    public var hashValue: Int {
//        return Int(bitPattern: CFHash(self))
//    }
//    public static func ==(a: CFString, b: CFString) -> Bool {
//        return CFEqual(a, b)
//    }
//}


class ImageIOVC: UIViewController {

    @IBOutlet var iv : UIImageView!

    @IBAction func doButton (_ sender: Any!) {
        let url = Bundle.main.url(forResource:"colson", withExtension: "jpg")!
        let src = CGImageSourceCreateWithURL(url as CFURL, nil)!
        let result = CGImageSourceCopyPropertiesAtIndex(src, 0, nil)! as NSDictionary
        print(result)
        // just proving it really is a dictionary
        let width = result[kCGImagePropertyPixelWidth] as! CGFloat
        let height = result[kCGImagePropertyPixelHeight] as! CGFloat
        print("\(width) by \(height)")
    }

    @IBAction func doButton2 (_ sender: Any!) {
        let url = Bundle.main.url(forResource:"colson", withExtension: "jpg")!
        let src = CGImageSourceCreateWithURL(url as CFURL, nil)!
        let scale = UIScreen.main.scale
        let w = self.iv.bounds.width * scale
        let d : NSDictionary = [
            kCGImageSourceShouldAllowFloat : true ,
            kCGImageSourceCreateThumbnailWithTransform : true ,
            kCGImageSourceCreateThumbnailFromImageAlways : true ,
            kCGImageSourceThumbnailMaxPixelSize : w
        ]
        let imref = CGImageSourceCreateThumbnailAtIndex(src, 0, d)!
        let im = UIImage(cgImage: imref, scale: scale, orientation: .up)
        self.iv.image = im
        print(im)
        print(im.size)
    }

    @IBAction func doButton3 (_ sender: Any!) {
        let url = Bundle.main.url(forResource:"colson", withExtension: "jpg")!
        let src = CGImageSourceCreateWithURL(url as CFURL, nil)!
        let fm = FileManager.default
        let suppurl = try! fm.url(for:.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let tiff = suppurl.appendingPathComponent("mytiff.tiff")
        let dest = CGImageDestinationCreateWithURL(tiff as CFURL, kUTTypeTIFF, 1, nil)!
        CGImageDestinationAddImageFromSource(dest, src, 0, nil)
        let ok = CGImageDestinationFinalize(dest)
        if ok {
            print("tiff image written to disk")
        } else {
            print("something went wrong")
        }
    }
    
}
