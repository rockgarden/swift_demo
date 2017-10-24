
import UIKit

class AttributedStringDrawingVC : UIViewController {

    @IBOutlet var drawer : AttributedStringDrawer!
    @IBOutlet var iv : UIImageView!
    lazy var content : NSAttributedString = makeAttributedString()

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
        let s = makeAttributedString()
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
                s2.addAttribute(NSAttributedStringKey.paragraphStyle, value: p, range: NSMakeRange(0,1))
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
                s2.addAttribute(NSAttributedStringKey.paragraphStyle, value: p, range: NSMakeRange(0,1))
                con.minimumScaleFactor = 0.5
                s2.boundingRect(with:CGSize(CGFloat(w),10000), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], context: con)
                print(w, con.totalBounds, con.actualScaleFactor)
            }
        }
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
            debugLog(context.totalBounds)
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

