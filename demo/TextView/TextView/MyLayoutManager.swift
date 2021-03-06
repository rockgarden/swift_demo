//
//  MyLayoutManager.swift
//  TextView
//
/// NSLayoutManager对象协调NSTextStorage对象中保存的字符的布局和显示。 它将Unicode字符代码映射到字形，将字符串设置在一系列NSTextContainer对象中，并将它们显示在一系列NSTextView对象中。 除了其核心功能之外，NSLayoutManager对象协调其NSTextView对象，为这些文本视图提供服务，以支持NSRulerView实例编辑段落样式，并处理字体中不固有的文本属性的布局和显示（例如 下划线或删除线）。 您可以创建一个NSLayoutManager的子类来处理附加的文本属性，无论其是否固有。

import UIKit

class MyLayoutManager : NSLayoutManager {

    var wordRange : NSRange = NSMakeRange(0,0)

    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange:glyphsToShow, at:origin)
        if self.wordRange.length == 0 {
            return
        }

        /// 如果charRange的长度为0，则所得到的字形范围是与前一个字符对应的字形之后的零长度范围，actualCharRange也将为零长度。 如果charRange扩展到文本长度之外，则该方法将结果截断为文本中的字形数。
        /// 如果未启用非连续布局，则此方法强制生成直到并包括指定范围结尾的所有字符的字形。
        var range = self.glyphRange(forCharacterRange:self.wordRange, actualCharacterRange:nil)

        range = NSIntersectionRange(glyphsToShow, range)
        if range.length == 0 {
            return
        }
        if let tc = self.textContainer(forGlyphAt:range.location, effectiveRange:nil) {
            var r = self.boundingRect(forGlyphRange:range, in:tc)
            r.origin.x += origin.x
            r.origin.y += origin.y
            r = r.insetBy(dx: -2, dy: 0)
            let c = UIGraphicsGetCurrentContext()!
            c.saveGState()
            c.setStrokeColor(UIColor.black.cgColor)
            c.setLineWidth(1.0)
            c.stroke(r)
            c.restoreGState()
        }
    }
    
}


