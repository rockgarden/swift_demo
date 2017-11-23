
import UIKit
import CoreText

/// 创建一个新的继承于UIScrollView
class CTView: UIScrollView {
    // MARK: - Properties
    var imageIndex: Int!
    
    //1
    func buildFrames(withAttrString attrString: NSAttributedString,
                     andImages images: [[String: Any]]) {
        imageIndex = 0
        
        //3
        isPagingEnabled = true
        //4
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        //4
        var pageView = UIView()
        var textPos = 0
        var columnIndex: CGFloat = 0
        var pageIndex: CGFloat = 0
        let settings = CTSettings()
        //5
        while textPos < attrString.length {
            //1
            if columnIndex.truncatingRemainder(dividingBy: settings.columnsPerPage) == 0 {
                columnIndex = 0
                pageView = UIView(frame: settings.pageRect.offsetBy(dx: pageIndex * bounds.width, dy: 0))
                addSubview(pageView)
                //2
                pageIndex += 1
            }
            //3
            let columnXOrigin = pageView.frame.size.width / settings.columnsPerPage
            let columnOffset = columnIndex * columnXOrigin
            let columnFrame = settings.columnRect.offsetBy(dx: columnOffset, dy: 0)
            
            //1
            let path = CGMutablePath()
            path.addRect(CGRect(origin: .zero, size: columnFrame.size))
            let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, nil)
            //2 
            let column = CTColumnView(frame: columnFrame, ctframe: ctframe)
            if images.count > imageIndex {
                attachImagesWithFrame(images, ctframe: ctframe, margin: settings.margin, columnView: column)
            }
            pageView.addSubview(column)
            //3
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            textPos += frameRange.length
            //4
            columnIndex += 1
        }
        contentSize = CGSize(width: CGFloat(pageIndex) * bounds.size.width,
                             height: bounds.size.height)
    }
    
    func attachImagesWithFrame(_ images: [[String: Any]],
                               ctframe: CTFrame,
                               margin: CGFloat,
                               columnView: CTColumnView) {
        //1
        let lines = CTFrameGetLines(ctframe) as NSArray
        //2
        var origins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &origins)
        //3
        var nextImage = images[imageIndex]
        guard var imgLocation = nextImage["location"] as? Int else {
            return
        }
        //4
        for lineIndex in 0..<lines.count {
            let line = lines[lineIndex] as! CTLine
            //5
            if let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun],
                let imageFilename = nextImage["filename"] as? String,
                let img = UIImage(named: imageFilename)  {
                for run in glyphRuns {
                    // 1
                    let runRange = CTRunGetStringRange(run)
                    if runRange.location > imgLocation || runRange.location + runRange.length <= imgLocation {
                        continue
                    }
                    //2
                    var imgBounds: CGRect = .zero
                    var ascent: CGFloat = 0
                    imgBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, nil, nil))
                    imgBounds.size.height = ascent
                    //3
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    imgBounds.origin.x = origins[lineIndex].x + xOffset
                    imgBounds.origin.y = origins[lineIndex].y
                    //4
                    columnView.images += [(image: img, frame: imgBounds)]
                    //5
                    imageIndex! += 1
                    if imageIndex < images.count {
                        nextImage = images[imageIndex]
                        imgLocation = (nextImage["location"] as AnyObject).intValue
                    }
                }
            }
        }
    }
}
