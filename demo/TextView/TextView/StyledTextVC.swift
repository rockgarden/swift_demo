
import UIKit

class StyledTextVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
    }
}

class StyledText: UIScrollView {

    @NSCopying var text = NSAttributedString() // shut up the compiler
    var lm : NSLayoutManager!
    var tc : NSTextContainer!
    var tc2 : NSTextContainer!
    var ts : NSTextStorage!
    var r1 = CGRect.zero
    var r2 = CGRect.zero

    override func awakeFromNib() {
        super.awakeFromNib()

        let path = Bundle.main.path(forResource: "states", ofType: "txt")!
        let s = try! String(contentsOfFile: path)

        let desc = UIFontDescriptor(name:"Didot", size:18)
        let atts = [
            UIFontFeatureTypeIdentifierKey:kLetterCaseType,
            UIFontFeatureSelectorIdentifierKey:kSmallCapsSelector
        ]
        let desc2 = desc.addingAttributes(
            [UIFontDescriptorFeatureSettingsAttribute:[atts]]
        )
        let f = UIFont(descriptor: desc2, size: 0)

        let d = [NSFontAttributeName:f]
        let mas = NSMutableAttributedString(string: s, attributes: d)

        /// 替代lend()写法
        do {
            var para = NSMutableParagraphStyle() {
                didSet{
                    para.alignment = .center
                }
            }
        }

        mas.addAttribute(NSParagraphStyleAttributeName,
                         value: lend(closure: {(para:NSMutableParagraphStyle) in
                            para.alignment = .center}),
                         range: NSMakeRange(0,mas.length))
        self.text = mas

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
    }

    // FIXME: navBar引起高度错位
    override func layoutSubviews() {
        super.layoutSubviews()
        var r1 = self.bounds
        r1.origin.y += 2 // a little top space
        r1.size.width /= 2.0 // column 1
        var r2 = r1
        r2.origin.x += r2.size.width // column 2
        let lm = MyLayoutManager()
        let ts = NSTextStorage(attributedString:self.text)
        ts.addLayoutManager(lm)
        let tc = NSTextContainer(size:r1.size)
        lm.addTextContainer(tc)
        let tc2 = NSTextContainer(size:r2.size)
        lm.addTextContainer(tc2)

        self.lm = lm; self.ts = ts; self.tc = tc; self.tc2 = tc2
        self.r1 = r1; self.r2 = r2
    }

    override func draw(_ rect: CGRect) {
        /// 返回给定文本容器中布局的字形的范围。
        /// 这是一个比类似的文本容器（forGlyphAt：effectiveRange :)更有效的方法。
        /// 如果需要，执行字形生成和布局。
        let range1 = self.lm.glyphRange(for:self.tc)

        self.lm.drawBackground(forGlyphRange:range1, at: self.r1.origin)
        self.lm.drawGlyphs(forGlyphRange:range1, at: self.r1.origin)
        let range2 = self.lm.glyphRange(for:self.tc2)
        self.lm.drawBackground(forGlyphRange:range2, at: self.r2.origin)
        self.lm.drawGlyphs(forGlyphRange:range2, at: self.r2.origin)
    }

    func tapped (_ g : UIGestureRecognizer) {
        // which column is it in?
        var p = g.location(in:self)
        var tc = self.tc!
        if !self.r1.contains(p) {
            tc = self.tc2!
            p.x -= self.r1.size.width
        }
        var f : CGFloat = 0
        let ix = self.lm.glyphIndex(for:p, in:tc, fractionOfDistanceThroughGlyph:&f)
        var glyphRange : NSRange = NSMakeRange(0,0)
        self.lm.lineFragmentRect(forGlyphAt:ix, effectiveRange:&glyphRange)
        if ix == glyphRange.location && f == 0.0 {
            return
        }
        if ix == glyphRange.location + glyphRange.length - 1 && f == 1.0 {
            return
        }
        // 结束时消除控制字符字形 eliminate control character glyphs at end
        func lastCharIsControl () -> Bool {
            let lastCharRange = glyphRange.location + glyphRange.length - 1
            let property = self.lm.propertyForGlyph(at:lastCharRange)
            // let ok = property.contains[.ControlCharacter]
            let mask1 = property.rawValue
            let mask2 = NSGlyphProperty.controlCharacter.rawValue
            return mask1 & mask2 != 0
        }
        while lastCharIsControl() {
            glyphRange.length -= 1
        }
        // got the range!
        let characterRange = self.lm.characterRange(forGlyphRange:glyphRange, actualGlyphRange:nil)
        let s = (self.text.string as NSString).substring(with:characterRange)
        print("you tapped \(s)")
        let lm = self.lm as! MyLayoutManager
        lm.wordRange = characterRange
        self.setNeedsDisplay()
        UIApplication.shared.beginIgnoringInteractionEvents()
        delay(0.3) {
            lm.wordRange = NSMakeRange(0, 0)
            self.setNeedsDisplay()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
}
