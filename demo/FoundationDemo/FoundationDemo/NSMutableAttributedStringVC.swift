
import UIKit


class NSMutableAttributedStringVC : UIViewController {

    @IBOutlet var lab : UILabel!
    @IBOutlet var tv : UITextView!
    @IBOutlet weak var UnderliningLab: UILabel!

    let which = 5 // 0 ... 5

    override func viewDidLoad() {
        super.viewDidLoad()

        // self.tv.textContainer.lineFragmentPadding = 0 // make it just like the label
        // to show that under identical conditions they do draw identically

        self.tv.isScrollEnabled = false // in case setting in the nib doesn't work

        var content : NSMutableAttributedString!
        var content2 : NSMutableAttributedString!

        switch which {
        case 0, 1, 4, 5:
            let s1 = "The Gettysburg Address, as delivered on a certain occasion " +
            "(namely Thursday, November 19, 1863) by A. Lincoln"
            content = NSMutableAttributedString(string:s1, attributes:[
                NSFontAttributeName: UIFont(name:"Arial-BoldMT", size:15)!,
                NSForegroundColorAttributeName: UIColor(red:0.251, green:0.000, blue:0.502, alpha:1)
                ])
            let r = (s1 as NSString).range(of:"Gettysburg Address")
            content.addAttributes([
                NSStrokeColorAttributeName: UIColor.red,
                NSStrokeWidthAttributeName: -2.0
                ], range: r)
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.textContainerInset = UIEdgeInsetsMake(30,0,0,0)
            if which > 0 {fallthrough}
        case 1, 4, 5:
            let para = NSMutableParagraphStyle()
            para.headIndent = 10
            para.firstLineHeadIndent = 10
            para.tailIndent = -10
            para.lineBreakMode = .byWordWrapping
            para.alignment = .center
            para.paragraphSpacing = 15
            content.addAttribute(
                NSParagraphStyleAttributeName,
                value:para, range:NSMakeRange(0,1))
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.textContainerInset = UIEdgeInsetsMake(30,0,0,0)
            if which >= 4 {fallthrough}
        case 2, 3, 4, 5:
            let s2 = "Fourscore and seven years ago, our fathers brought forth " +
                "upon this continent a new nation, conceived in liberty and " +
            "dedicated to the proposition that all men are created equal."
            content2 = NSMutableAttributedString(string:s2, attributes: [
                NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:16)!
                ])
            content2.addAttributes([
                NSFontAttributeName: UIFont(name:"HoeflerText-Black", size:24)!,
                NSExpansionAttributeName: 0.3,
                NSKernAttributeName: -4 // negative kerning bug fixed in iOS 8
                // but they broke it again in iOS 8.3!
                // but they fixed it again in iOS 9!
                ], range:NSMakeRange(0,1))
            self.lab.attributedText = content2
            self.tv.attributedText = content2
            self.tv.textContainerInset = UIEdgeInsetsMake(30,0,0,0)
            if which > 2 {fallthrough}
        case 3, 4, 5:
            content2.addAttribute(NSParagraphStyleAttributeName,
                                  value:lend {
                                    (para:NSMutableParagraphStyle) in
                                    para.headIndent = 10
                                    para.firstLineHeadIndent = 10
                                    para.tailIndent = -10
                                    para.lineBreakMode = .byWordWrapping
                                    para.alignment = .justified
                                    para.lineHeightMultiple = 1.2
                                    para.hyphenationFactor = 1.0
            }, range:NSMakeRange(0,1))
            self.lab.attributedText = content2
            self.tv.attributedText = content2
            self.tv.textContainerInset = UIEdgeInsetsMake(20,0,0,0)
            if which > 3 {fallthrough}
        case 4, 5:
            let end = content.length
            content.replaceCharacters(in:NSMakeRange(end, 0), with:"\n")
            content.append(content2)
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.textContainerInset = UIEdgeInsetsMake(20,0,0,0)

            // need this for a different book example
            var range : NSRange = NSMakeRange(0,0)
            let d = content.attributes(at:content.length-1, effectiveRange:&range)
            _ = d

            if which > 4 {fallthrough}
        case 5:
            // demonstrating efficient cycling through style runs

            content.enumerateAttribute(NSFontAttributeName,
                                       in:NSMakeRange(0,content.length),
                                       options:.longestEffectiveRangeNotRequired) {
                                        value, range, stop in
                                        print(range)
                                        let font = value as! UIFont
                                        if font.pointSize == 15 {
                                            content.addAttribute(NSFontAttributeName,
                                                                 value:UIFont(name: "Arial-BoldMT", size:20)!,
                                                                 range:range)
                                        }
            }
            self.lab.attributedText = content
            self.tv.attributedText = content
            self.tv.textContainerInset = UIEdgeInsetsMake(0,0,0,0)
        default:break
        }
        
        doUnderlining()
    }

    func doUnderlining() {
        //        let mas = NSMutableAttributedString(string: "Buy beer", attributes: [
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue
        //            ])

        let mas = NSMutableAttributedString(string: "Buy beer")

        // this didn't work in iOS 8 until it was fixed in iOS 8.3
        //        mas.addAttributes([
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
        //            ], range: NSMakeRange(4, mas.length-4))

        // showing that it is necessary to use freaking bitwise-or to form this bitmask still
        let under = NSUnderlineStyle.styleThick.rawValue | NSUnderlineStyle.patternDash.rawValue
        mas.addAttributes([
            NSUnderlineStyleAttributeName: under
            ], range: NSMakeRange(4, mas.length-4))

        UnderliningLab.attributedText = mas
    }

    @IBOutlet var secretLab : UILabel!
    /// AttributedText As Secret Marking
    ///
    /// - Parameter sender: UIButton
    @IBAction func doUpdateSecretLabel(_ sender: Any?) {
        let mas = self.secretLab.attributedText!.mutableCopy() as! NSMutableAttributedString
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
        self.secretLab.attributedText = mas
    }
}
