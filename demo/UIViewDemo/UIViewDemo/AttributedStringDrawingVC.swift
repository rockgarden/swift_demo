
import UIKit

class AttributedStringDrawingVC : UIViewController {

    @IBOutlet var drawer : AttributedStringDrawer!
    @IBOutlet var iv : UIImageView!
    lazy var content : NSAttributedString = self.makeAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()

        // draw into 280 x 250 image
        let rect = CGRect(0,0,280,250)
        let im = imageOfSize(rect.size) {
            let con = UIGraphicsGetCurrentContext()!
            UIColor.white.setFill()
            con.fill(rect)
            self.content.draw(in:rect)
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
        print("boundingRect:", r, "==", con.totalBounds)
        
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


class AttributedStringDrawer : UIView {

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

            /// 当绘制字符串时，提供以下常量作为渲染选项
            /// - truncatesLastVisibleLine 截断并将省略号字符添加到最后一个可见行，如果文本不符合指定的边界。如果NSStringDrawingUsesLineFragmentOrigin也未设置，则忽略此选项。 另外，换行模式必须是NSLineBreakByWordWrapping或NSLineBreakByCharWrapping，以使此选项生效。 可以在绘图方法的属性字典参数中传递的段落样式中指定换行模式。
            /// - usesLineFragmentOrigin 指定的起点是线段起点，而不是基线起点。
            let options : NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesLineFragmentOrigin]

            let context = NSStringDrawingContext()
            context.minimumScaleFactor = 0.5

            attributedText.draw(with:r, options: options, context: context)
            debugLog(message: context.totalBounds)
        case 2:
            let lm = NSLayoutManager()
            let ts = NSTextStorage(attributedString: attributedText)
            ts.addLayoutManager(lm)
            let tc = NSTextContainer(size: rect.size)
            lm.addTextContainer(tc)
            tc.lineBreakMode = .byTruncatingTail
            tc.lineFragmentPadding = 0
            let r = lm.glyphRange(for:tc)
            lm.drawBackground(forGlyphRange:r, at:CGPoint(0,2))
            lm.drawGlyphs(forGlyphRange: r, at:CGPoint(0,2))
        default:break
        }
    }
}

