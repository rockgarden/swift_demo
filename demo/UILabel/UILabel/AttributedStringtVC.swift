
import UIKit

class AttributedStringVC : UIViewController {

    @IBOutlet var drawer : StringDrawer!
    @IBOutlet var iv : UIImageView!
    lazy var content : NSAttributedString = self.makeAttributedString()
    @IBOutlet var lab : UILabel!

    @IBAction func doUpdateLabel(_ sender: Any?) {
        let mas = self.lab.attributedText!.mutableCopy() as! NSMutableAttributedString
        let r = (mas.string as NSString).range(of:"^0")
        if r.length > 0 {
            mas.addAttribute("HERE", value: 1, range: r)
            mas.replaceCharacters(in:r, with: Date().description)
        } else {
            mas.enumerateAttribute("HERE", in: NSMakeRange(0, mas.length)) {
                value, r, stop in
                if let value = value as? Int, value == 1 {
                    mas.replaceCharacters(in:r, with: Date().description)
                    stop.pointee = true
                }
            }
        }
        self.lab.attributedText = mas
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // draw into 280 x 250 image
        let rect = CGRect(0,0,280,250)

        var im: UIImage!
        if #available(iOS 10.0, *) {
            let r = UIGraphicsImageRenderer(size:rect.size)
            im = r.image {
                ctx in let con = ctx.cgContext
                UIColor.white.setFill()
                con.fill(rect)
                content.draw(in:rect) // draw attributed string
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
            UIColor.white.setFill()
            UIGraphicsGetCurrentContext()!.fill(rect)
            content.draw(in:rect) // draw attributed string
            im = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        // display the image
        self.iv.image = im
        
        // another way: draw the string in a view's drawRect:
        self.drawer.attributedText = content

        moreStringDrawingTest()
    }

    func moreStringDrawingTest() {
        let con = NSStringDrawingContext()

        // testing string measurement
        let s = self.makeAttributedString()
        let r = s.boundingRect(with:CGSize(400,10000), options: .usesLineFragmentOrigin, context: con)
        print("boundingRect:", r, "==", con.totalBounds) // about 150 tall, sounds right to me :)

        // testing minimumScaleFactor; we never get an actual scale factor other than 1
        do {
            for w in [240,230,220] {
                let s2 = NSMutableAttributedString(string:"Little poltergeists make up the principle form")
                let p = lend {
                    (p:NSMutableParagraphStyle) in
                    p.allowsDefaultTighteningForTruncation = false
                    p.lineBreakMode = .byTruncatingTail
                }
                s2.addAttribute(NSParagraphStyleAttributeName, value: p, range: NSMakeRange(0,1))
                con.minimumScaleFactor = 0.5
                s2.boundingRect(with:CGSize(CGFloat(w),10000), options: [.usesLineFragmentOrigin], context: con)
                print(w, con.totalBounds, con.actualScaleFactor)
            }
        }

        do {
            for w in [240,230,220] {
                let s2 = NSMutableAttributedString(string:"Little poltergeists make up the principle form")
                let p = lend {
                    (p:NSMutableParagraphStyle) in
                    // this new feature does make a difference, but not in the scale factor
                    p.allowsDefaultTighteningForTruncation = true
                    p.lineBreakMode = .byTruncatingTail
                }
                s2.addAttribute(NSParagraphStyleAttributeName, value: p, range: NSMakeRange(0,1))
                con.minimumScaleFactor = 0.5
                s2.boundingRect(with:CGSize(CGFloat(w),10000), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], context: con)
                print(w, con.totalBounds, con.actualScaleFactor)
            }
        }
    }

    fileprivate func makeAttributedString() -> NSAttributedString {
        var content : NSMutableAttributedString!
        var content2 : NSMutableAttributedString!
        
        let s1 = "The Gettysburg Address, as delivered on a certain occasion " +
        "(namely Thursday, November 19, 1863) by A. Lincoln"
        content = NSMutableAttributedString(string:s1, attributes:[
            NSFontAttributeName: UIFont(name:"Arial-BoldMT", size:15)!,
            NSForegroundColorAttributeName: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)]
        )
        let r = (s1 as NSString).range(of:"Gettysburg Address")
        let atts : [String:Any] = [
            NSStrokeColorAttributeName: UIColor.red,
            NSStrokeWidthAttributeName: -2.0
        ]
        content.addAttributes(atts, range: r)
        
        content.addAttribute(NSParagraphStyleAttributeName,
            value:lend() {
                (para : NSMutableParagraphStyle) in
                para.headIndent = 10
                para.firstLineHeadIndent = 10
                para.tailIndent = -10
                para.lineBreakMode = .byWordWrapping
                para.alignment = .center
                para.paragraphSpacing = 15
        }, range:NSMakeRange(0,1))
        
        var s2 = "Fourscore and seven years ago, our fathers brought forth " +
            "upon this continent a new nation, conceived in liberty and dedicated "
         s2 = s2 + "to the proposition that all men are created equal."
        content2 = NSMutableAttributedString(string:s2, attributes: [
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
            ])
        content2.addAttributes([
            NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
            NSExpansionAttributeName: 0.3,
            NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
            ], range:NSMakeRange(0,1))
        
        content2.addAttribute(NSParagraphStyleAttributeName,
            value:lend() {
            (para2 : NSMutableParagraphStyle) in
            para2.headIndent = 10
            para2.firstLineHeadIndent = 10
            para2.tailIndent = -10
            para2.lineBreakMode = .byWordWrapping
            para2.alignment = .justified
            para2.lineHeightMultiple = 1.2
            para2.hyphenationFactor = 1.0
        }, range:NSMakeRange(0,1))
        
        let end = content.length
        content.replaceCharacters(in:NSMakeRange(end, 0), with:"\n")
        content.append(content2)
        
        return content
    }

}


class StringDrawer : UIView {
    @NSCopying var attributedText : NSAttributedString! {
        didSet {
            self.setNeedsDisplay()
        }
    }

    let which = 1

    override func draw(_ rect: CGRect) {
        switch which {
        case 1:
            let r = rect.offsetBy(dx: 0, dy: 2)
            // just proving it's now an Option Set
            let options : NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesLineFragmentOrigin]
            let context = NSStringDrawingContext()
            context.minimumScaleFactor = 0.5 // does nothing
            self.attributedText.draw(with:r, options: options, context: nil)
            print(context.totalBounds)
        case 2:
            let lm = NSLayoutManager()
            let ts = NSTextStorage(attributedString:self.attributedText)
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size:rect.size)
            lm.addTextContainer(tc)
            tc.lineBreakMode = .byTruncatingTail //
            tc.lineFragmentPadding = 0
            let r = lm.glyphRange(for:tc)
            lm.drawBackground(forGlyphRange:r, at:CGPoint(0,2))
            lm.drawGlyphs(forGlyphRange: r, at:CGPoint(0,2))
        default:break
        }

    }
}

