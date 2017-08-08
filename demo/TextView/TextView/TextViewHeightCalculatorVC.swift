//
//  ViewController.swift
//  TextViewHeightCalculator
//
//  Created by Sandeep Bhandari on 1/19/17.
//  Copyright © 2017 Sandeep Bhandari. All rights reserved.
//

import UIKit

class TextViewHeightCalculatorVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    @IBOutlet weak var myLabel: UILabel!
    var attribute : NSAttributedString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let styledHTML = "Chyawanprash <b>is</b> a common household herbal tonic in India that is considered to be a spoonful of health and longevity. Made with a base of amla fruits, which have the highest concentration of Vitamin C in the plant kingdom, chyawanprash is a mixture of over 49 herbs including ashwagandha, vidarikand, pueraria, pippali, long pepper, white sandalwood, cardamom, tulsi, brahmi, arjun, jatamansi and neem. I remember that as a child, I was forced to eat a spoonful of this sticky, dark substance every day to help build immunity. That was quite possibly the healthiest year of my <b>life.</b>";
        
        let data = styledHTML.data(using: String.Encoding.utf8, allowLossyConversion: false)
        attribute = try! NSMutableAttributedString(data: data!, options: [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
            ], documentAttributes: nil)
        
        
        var textViewFont : UIFont!
        
        let lastCharacterRange = NSMakeRange(attribute.length - 1, 1)
        let lastCharacter = attribute.attributedSubstring(from: lastCharacterRange)
        if lastCharacter.string == "\n" {
            let newRange = NSMakeRange(0, attribute.length - 2)
            attribute = attribute.attributedSubstring(from: newRange) as! NSMutableAttributedString
        }
        
        attribute.enumerateAttribute(NSFontAttributeName,
                                   in: NSMakeRange(0, attribute.length),
                                   options: NSAttributedString.EnumerationOptions(rawValue: 0), using: { (value, range, stop) in
                                    if let font = value as? UIFont {
                                        textViewFont = font
                                    }
        })
        
        let currentWidth = view.frame.size.width
        let textStorage = NSTextStorage(attributedString: attribute)
        let textContainer = NSTextContainer(size: CGSize(width: currentWidth, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        
        textStorage.addAttribute(NSFontAttributeName, value: textViewFont!, range: NSMakeRange(0, attribute.length - 1))
        textContainer.lineFragmentPadding = 0.0
        
        layoutManager.glyphRange(for: textContainer)
        let newSize = layoutManager.boundingRect(forGlyphRange: NSMakeRange(0, attribute.length - 1), in: textContainer)
        self.myTextViewHeight.constant = newSize.height
        self.myTextView.layoutIfNeeded()
        self.myTextView.attributedText = attribute
        
        self.labelHeight.constant = newSize.height
        self.myLabel.layoutIfNeeded()
        self.myLabel.attributedText = attribute
    }
    
}

