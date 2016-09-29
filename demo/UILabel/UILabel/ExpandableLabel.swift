//
// ExpandableLabel.swift
//
// Copyright (c) 2015 apploft. GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/**
 * The delegate of ExpandableLabel.
 */
public protocol ExpandableLabelDelegate: NSObjectProtocol {
	func willExpandLabel(label: ExpandableLabel)
	func didExpandLabel(label: ExpandableLabel)
	func shouldExpandLabel(label: ExpandableLabel) -> Bool

	func willCollapseLabel(label: ExpandableLabel)
	func didCollapseLabel(label: ExpandableLabel)
	func shouldCollapseLabel(label: ExpandableLabel) -> Bool
}

extension ExpandableLabelDelegate {
	public func shouldExpandLabel(label: ExpandableLabel) -> Bool {
		return Static.DefaultShouldExpandValue
	}
	public func shouldCollapseLabel(label: ExpandableLabel) -> Bool {
		return Static.DefaultShouldCollapseValue
	}
	public func willCollapseLabel(label: ExpandableLabel) { }
	public func didCollapseLabel(label: ExpandableLabel) { }
}

private struct Static {
	private static let DefaultShouldExpandValue: Bool = true
	private static let DefaultShouldCollapseValue: Bool = false
}

/**
 * ExpandableLabel
 */
public class ExpandableLabel: UILabel {

	/// The delegate of ExpandableLabel
	weak public var delegate: ExpandableLabelDelegate?

	/// Set 'true' if the label should be collapsed or 'false' for expanded.
	@IBInspectable public var collapsed: Bool = true {
		didSet {
			super.attributedText = (collapsed) ? self.collapsedText : self.expandedText
			super.numberOfLines = (collapsed) ? self.collapsedNumberOfLines : 0
		}
	}

	/// Set the link name (and attributes) that is shown when collapsed.
	/// The default value is "More". Cannot be nil.
	@IBInspectable public var collapsedAttributedLink: NSAttributedString! {
		didSet {
			self.collapsedAttributedLink = collapsedAttributedLink.copyWithAddedFontAttribute(font)
		}
	}

	/// Set the ellipsis that appears just after the text and before the link.
	/// The default value is "...". Can be nil.
	public var ellipsis: NSAttributedString? {
		didSet {
			self.ellipsis = ellipsis?.copyWithAddedFontAttribute(font)
		}
	}

	//
	// MARK: Private
	//

	private var expandedText: NSAttributedString?
	private var collapsedText: NSAttributedString?
	private var linkHighlighted: Bool = false
	private let touchSize = CGSize(width: 44, height: 44)
	private var linkRect: CGRect?
	private var collapsedNumberOfLines: NSInteger = 0

	public override var numberOfLines: NSInteger {
		didSet {
			collapsedNumberOfLines = numberOfLines
		}
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	init() {
		super.init(frame: CGRectZero)
	}

	private func commonInit() {
		userInteractionEnabled = true
		lineBreakMode = NSLineBreakMode.ByClipping
		numberOfLines = 3
		collapsedAttributedLink = NSAttributedString(string: "More", attributes: [NSFontAttributeName: UIFont.italicSystemFontOfSize(font.pointSize)])
		ellipsis = NSAttributedString(string: "...")
	}

	public override var text: String? {
		set(text) {
			if let text = text {
				self.attributedText = NSAttributedString(string: text)
			} else {
				self.attributedText = nil
			}
		}
		get {
			return self.attributedText?.string
		}
	}

	public override var attributedText: NSAttributedString? {
		set(attributedText) {
			if let attributedText = attributedText where attributedText.length > 0 {
				self.expandedText = attributedText.copyWithAddedFontAttribute(font)
				self.collapsedText = getCollapsedTextForText(self.expandedText, link: (linkHighlighted) ? collapsedAttributedLink.copyWithHighlightedColor() : collapsedAttributedLink)
				super.attributedText = (self.collapsed) ? self.collapsedText : self.expandedText;
			} else {
				super.attributedText = nil
			}
		}
		get {
			return super.attributedText
		}
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		attributedText = expandedText
	}

	private func textWithLinkReplacement(line: CTLineRef, text: NSAttributedString, linkName: NSAttributedString) -> NSAttributedString {
		let lineText = text.textForLine(line)
		var lineTextWithLink = lineText
		(lineText.string as NSString).enumerateSubstringsInRange(NSMakeRange(0, lineText.length), options: [.ByWords, .Reverse]) { (word, subRange, enclosingRange, stop) -> () in
			let lineTextWithLastWordRemoved = lineText.attributedSubstringFromRange(NSMakeRange(0, subRange.location))
			let lineTextWithAddedLink = NSMutableAttributedString(attributedString: lineTextWithLastWordRemoved)
			if let ellipsis = self.ellipsis {
				lineTextWithAddedLink.appendAttributedString(ellipsis)
				lineTextWithAddedLink.appendAttributedString(NSAttributedString(string: " ", attributes: [NSFontAttributeName: self.font]))
			}
			lineTextWithAddedLink.appendAttributedString(linkName)
			let fits = self.textFitsWidth(lineTextWithAddedLink)
			if (fits == true) {
				lineTextWithLink = lineTextWithAddedLink
				let lineTextWithLastWordRemovedRect = lineTextWithLastWordRemoved.boundingRectForWidth(self.frame.size.width)
				let wordRect = linkName.boundingRectForWidth(self.frame.size.width)
				self.linkRect = CGRectMake(lineTextWithLastWordRemovedRect.size.width, self.font.lineHeight * CGFloat(self.collapsedNumberOfLines - 1), wordRect.size.width, wordRect.size.height)
				stop.memory = true
			}
		}
		return lineTextWithLink
	}

	private func getCollapsedTextForText(text: NSAttributedString?, link: NSAttributedString) -> NSAttributedString? {
		if let text = text {
			let lines = text.linesForWidth(frame.size.width)
			if (collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count) {
				let lastLineRef = lines[collapsedNumberOfLines - 1] as CTLineRef
				let modifiedLastLineText = textWithLinkReplacement(lastLineRef, text: text, linkName: link)

				let collapsedLines = NSMutableAttributedString()
				if (collapsedNumberOfLines >= 2) {
					for index in 0...collapsedNumberOfLines - 2 {
						collapsedLines.appendAttributedString(text.textForLine(lines[index]))
					}
				}
				collapsedLines.appendAttributedString(modifiedLastLineText)
				return collapsedLines
			}
			return text
		} else {
			return nil;
		}
	}

	private func textFitsWidth(text: NSAttributedString) -> Bool {
		return (text.boundingRectForWidth(frame.size.width).size.height <= font.lineHeight) as Bool
	}

	// MARK: Touch Handling

	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		setLinkHighlighted(touches, event: event, highlighted: true)
	}

	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		setLinkHighlighted(touches, event: event, highlighted: false)
	}

	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if !collapsed {
			if shouldCollapse() {
				delegate?.willCollapseLabel(self)
				collapsed = true
				delegate?.didCollapseLabel(self)
				linkHighlighted = highlighted
				setNeedsDisplay()
			}
		} else {
			if shouldExpand() && setLinkHighlighted(touches, event: event, highlighted: false) {
				delegate?.willExpandLabel(self)
				collapsed = false
				delegate?.didExpandLabel(self)
			}
		}
	}

	public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		setLinkHighlighted(touches, event: event, highlighted: false)
	}

	private func setLinkHighlighted(touches: Set<UITouch>?, event: UIEvent?, highlighted: Bool) -> Bool {
		let touch = event?.allTouches()?.first
		let location = touch?.locationInView(self)
		if let location = location, linkRect = linkRect {
			let finger = CGRectMake(location.x - touchSize.width / 2, location.y - touchSize.height / 2, touchSize.width, touchSize.height);
			if collapsed && CGRectIntersectsRect(finger, linkRect) {
				linkHighlighted = highlighted
				setNeedsDisplay()
				return true
			}
		}
		return false
	}

	private func shouldCollapse() -> Bool {
		return delegate?.shouldCollapseLabel(self) ?? Static.DefaultShouldCollapseValue
	}

	private func shouldExpand() -> Bool {
		return delegate?.shouldExpandLabel(self) ?? Static.DefaultShouldExpandValue
	}
}

// MARK: Convenience Methods

private extension NSAttributedString {
	func hasFontAttribute() -> Bool {
		let font = self.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil) as? UIFont
		return font != nil
	}

	func copyWithAddedFontAttribute(font: UIFont) -> NSAttributedString {
		if (hasFontAttribute() == false) {
			let copy = NSMutableAttributedString(attributedString: self)
			copy.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, copy.length))
			return copy
		}
		return self.copy() as! NSAttributedString
	}

	func copyWithHighlightedColor() -> NSAttributedString {
		let alphaComponent = CGFloat(0.5)
		var baseColor: UIColor? = self.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as? UIColor
		if let color = baseColor { baseColor = color.colorWithAlphaComponent(alphaComponent) }
		else { baseColor = UIColor.blackColor().colorWithAlphaComponent(alphaComponent) }
		let highlightedCopy = NSMutableAttributedString(attributedString: self)
		highlightedCopy.removeAttribute(NSForegroundColorAttributeName, range: NSMakeRange(0, highlightedCopy.length))
		highlightedCopy.addAttribute(NSForegroundColorAttributeName, value: baseColor!, range: NSMakeRange(0, highlightedCopy.length))
		return highlightedCopy
	}

	func linesForWidth(width: CGFloat) -> Array<CTLineRef> {
		let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
		let frameSetterRef: CTFramesetterRef = CTFramesetterCreateWithAttributedString(self as CFAttributedStringRef)
		let frameRef: CTFrameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.CGPath, nil)

		let linesNS: NSArray = CTFrameGetLines(frameRef)
		let linesAO: [AnyObject] = linesNS as [AnyObject]
		let lines: [CTLine] = linesAO as! [CTLineRef]

		return lines
	}

	func textForLine(lineRef: CTLineRef) -> NSAttributedString {
		let lineRangeRef: CFRange = CTLineGetStringRange(lineRef)
		let range: NSRange = NSMakeRange(lineRangeRef.location, lineRangeRef.length)
		return self.attributedSubstringFromRange(range)
	}

	func boundingRectForWidth(width: CGFloat) -> CGRect {
		return self.boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)),
			options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
	}
}