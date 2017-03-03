
import UIKit

class RocketView : UIView {

    var which = 1

    @available(iOS 10.0, *)
    lazy var arrow : UIImage = {
        let r = UIGraphicsImageRenderer(size:CGSize(40,100))
        return r.image {
            _ in
            self.arrowImage()
        }
    }()

    init(mothed: Int) {
        super.init(frame:CGRect.zero)
        self.isOpaque = false
        self.which = mothed
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isOpaque = false
    }

    init(frame: CGRect, mothed: Int) {
        super.init(frame:frame)
        self.isOpaque = false
        self.which = mothed
    }

    func arrowImage () {
        //UIGraphicsBeginImageContextWithOptions(CGSize(40,100), false, 0.0)

        // obtain the current graphics context
        let con = UIGraphicsGetCurrentContext()!
        con.saveGState()

        // punch triangular hole in context clipping region
        con.move(to: CGPoint(10, 100))
        con.addLine(to: CGPoint(20, 90))
        con.addLine(to: CGPoint(30, 100))
        con.closePath()
        con.addRect(con.boundingBoxOfClipPath)
        con.clip(using: .evenOdd)

        // draw the vertical line, add its shape to the clipping region
        con.move(to: CGPoint(20, 100))
        con.addLine(to: CGPoint(20, 19))
        con.setLineWidth(20)
        con.replacePathWithStrokedPath()
        con.clip()

        // draw the gradient
        let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
        let colors : [CGFloat] = [
            0.8, 0.4, // starting color, transparent light gray
            0.1, 0.5, // intermediate color, darker less transparent gray
            0.8, 0.4, // ending color, transparent light gray
        ]
        let sp = CGColorSpaceCreateDeviceGray()
        let grad =
            CGGradient(colorSpace:sp, colorComponents: colors, locations: locs, count: 3)!
        con.drawLinearGradient(grad, start: CGPoint(9,0), end: CGPoint(31,0), options: [])

        con.restoreGState() // done clipping

        // draw the red triangle, the point of the arrow
        var stripes = UIImage()
        if #available(iOS 10.0, *) {
            let r = UIGraphicsImageRenderer(size:CGSize(4,4))
            stripes = r.image {
                ctx in
                let imcon = ctx.cgContext
                imcon.setFillColor(UIColor.red.cgColor)
                imcon.fill(CGRect(0,0,4,4))
                imcon.setFillColor(UIColor.blue.cgColor)
                imcon.fill(CGRect(0,0,4,2))
            }
        } else {
            // Fallback on earlier versions
        }


        let stripesPattern = UIColor(patternImage:stripes)
        stripesPattern.setFill()
        let p = UIBezierPath()
        p.move(to:CGPoint(0,25))
        p.addLine(to:CGPoint(20,0))
        p.addLine(to:CGPoint(40,25))
        p.fill()

        //        let im = UIGraphicsGetImageFromCurrentImageContext()!
        //        UIGraphicsEndImageContext()
        //
        //        return im
        //
    }

    override func draw(_ rect: CGRect) {
        switch which {
        case 1:
            let con = UIGraphicsGetCurrentContext()!

            // draw a black (by default) vertical line, the shaft of the arrow
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.strokePath()

            // draw a red triangle, the point of the arrow
            con.setFillColor(UIColor.red.cgColor)
            con.move(to:CGPoint(80, 25))
            con.addLine(to:CGPoint(100, 0))
            con.addLine(to:CGPoint(120, 25))
            con.fillPath()

            // snip a triangle out of the shaft by drawing in Clear blend mode
            con.move(to:CGPoint(90, 101))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 101))
            con.setBlendMode(.clear)
            con.fillPath()

        case 2:
            let p = UIBezierPath()
            // shaft
            p.move(to:CGPoint(100,100))
            p.addLine(to:CGPoint(100, 19))
            p.lineWidth = 20
            p.stroke()
            // point
            UIColor.red.set()
            p.removeAllPoints()
            p.move(to:CGPoint(80,25))
            p.addLine(to:CGPoint(100, 0))
            p.addLine(to:CGPoint(120, 25))
            p.fill()
            // snip
            p.removeAllPoints()
            p.move(to:CGPoint(90,101))
            p.addLine(to:CGPoint(100, 90))
            p.addLine(to:CGPoint(110, 101))
            p.fill(with:.clear, alpha:1.0)

        case 3:

            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()!

            // punch triangular hole in context clipping region
            con.move(to:CGPoint(90, 100))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 100))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using:.evenOdd)

            // draw the vertical line
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.strokePath()

            // draw the red triangle, the point of the arrow
            con.setFillColor(UIColor.red.cgColor)
            con.move(to:CGPoint(80, 25))
            con.addLine(to:CGPoint(100, 0))
            con.addLine(to:CGPoint(120, 25))
            con.fillPath()

        case 4:
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()!
            con.saveGState()

            // punch triangular hole in context clipping region
            con.move(to:CGPoint(90, 100))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 100))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using:.evenOdd)

            // draw the vertical line, add its shape to the clipping region
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.replacePathWithStrokedPath()
            con.clip()

            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.8, 0.4, // starting color, transparent light gray
                0.1, 0.5, // intermediate color, darker less transparent gray
                0.8, 0.4, // ending color, transparent light gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            // print(CGColorSpaceGetNumberOfComponents(sp))
            let grad =
                CGGradient(colorSpace:sp, colorComponents: colors, locations: locs, count: 3)!
            con.drawLinearGradient(grad, start: CGPoint(89,0), end: CGPoint(111,0), options:[])

            con.restoreGState() // done clipping

            // draw the red triangle, the point of the arrow
            con.setFillColor(UIColor.red.cgColor)
            con.move(to:CGPoint(80, 25))
            con.addLine(to:CGPoint(100, 0))
            con.addLine(to:CGPoint(120, 25))
            con.fillPath()

        case 5:
            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()!
            con.saveGState()

            // punch triangular hole in context clipping region
            con.move(to:CGPoint(90, 100))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 100))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using:.evenOdd)

            // draw the vertical line, add its shape to the clipping region
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.replacePathWithStrokedPath()
            con.clip()

            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.8, 0.4, // starting color, transparent light gray
                0.1, 0.5, // intermediate color, darker less transparent gray
                0.8, 0.4, // ending color, transparent light gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            let grad =
                CGGradient(colorSpace:sp, colorComponents: colors, locations: locs, count: 3)!
            con.drawLinearGradient(grad, start: CGPoint(89,0), end: CGPoint(111,0), options: [])

            con.restoreGState() // done clipping

            // draw the red triangle, the point of the arrow
            var stripes = UIImage()
            if #available(iOS 10.0, *) {
                let r = UIGraphicsImageRenderer(size:CGSize(4,4))
                stripes = r.image {
                    ctx in
                    let imcon = ctx.cgContext
                    imcon.setFillColor(UIColor.red.cgColor)
                    imcon.fill(CGRect(0,0,4,4))
                    imcon.setFillColor(UIColor.blue.cgColor)
                    imcon.fill(CGRect(0,0,4,2))
                }
            } else {
                UIGraphicsBeginImageContextWithOptions(CGSize(4,4), false, 0)
                let imcon = UIGraphicsGetCurrentContext()!
                imcon.setFillColor(UIColor.red.cgColor)
                imcon.fill(CGRect(0,0,4,4))
                imcon.setFillColor(UIColor.blue.cgColor)
                imcon.fill(CGRect(0,0,4,2))
                stripes = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
            }




            let stripesPattern = UIColor(patternImage: stripes)
            stripesPattern.setFill()
            let p = UIBezierPath()
            p.move(to:CGPoint(80,25))
            p.addLine(to:CGPoint(100,0))
            p.addLine(to:CGPoint(120,25))
            p.fill()

        case 6:

            // obtain the current graphics context
            let con = UIGraphicsGetCurrentContext()!
            con.saveGState()

            // punch triangular hole in context clipping region
            con.move(to:CGPoint(90, 100))
            con.addLine(to:CGPoint(100, 90))
            con.addLine(to:CGPoint(110, 100))
            con.closePath()
            con.addRect(con.boundingBoxOfClipPath)
            con.clip(using:.evenOdd)

            // draw the vertical line, add its shape to the clipping region
            con.move(to:CGPoint(100, 100))
            con.addLine(to:CGPoint(100, 19))
            con.setLineWidth(20)
            con.replacePathWithStrokedPath()
            con.clip()

            // draw the gradient
            let locs : [CGFloat] = [ 0.0, 0.5, 1.0 ]
            let colors : [CGFloat] = [
                0.8, 0.4, // starting color, transparent light gray
                0.1, 0.5, // intermediate color, darker less transparent gray
                0.8, 0.4, // ending color, transparent light gray
            ]
            let sp = CGColorSpaceCreateDeviceGray()
            let grad =
                CGGradient(colorSpace:sp, colorComponents: colors, locations: locs, count: 3)!
            con.drawLinearGradient (grad, start: CGPoint(89,0), end: CGPoint(111,0), options: [])

            con.restoreGState() // done clipping


            // draw the red triangle, the point of the arrow
            let sp2 = CGColorSpace(patternBaseSpace:nil)!
            con.setFillColorSpace(sp2)
            // hooray for Swift 2.0!
            let drawStripes : CGPatternDrawPatternCallback = {
                _, con in
                con.setFillColor(UIColor.red.cgColor)
                con.fill(CGRect(0,0,4,4))
                con.setFillColor(UIColor.blue.cgColor)
                con.fill(CGRect(0,0,4,2))
            }
            var callbacks = CGPatternCallbacks(
                version: 0, drawPattern: drawStripes, releaseInfo: nil)
            let patt = CGPattern(info:nil, bounds: CGRect(0,0,4,4),
                                 matrix: .identity,
                                 xStep: 4, yStep: 4,
                                 tiling: .constantSpacingMinimalDistortion,
                                 isColored: true, callbacks: &callbacks)!
            var alph : CGFloat = 1.0
            con.setFillPattern(patt, colorComponents: &alph)


            con.move(to:CGPoint(80, 25))
            con.addLine(to:CGPoint(100, 0))
            con.addLine(to:CGPoint(120, 25))
            con.fillPath()

        case 7:
            let con = UIGraphicsGetCurrentContext()!
            if #available(iOS 10.0, *) {
                self.arrow.draw(at:CGPoint(0,0))
            } else {
                // Fallback on earlier versions
            }
            for _ in 0..<3 {
                con.translateBy(x: 20, y: 100)
                con.rotate(by: 30 * .pi/180.0)
                con.translateBy(x: -20, y: -100)
                if #available(iOS 10.0, *) {
                    self.arrow.draw(at:CGPoint(0,0))
                } else {
                    // Fallback on earlier versions
                }
            }

        case 8:
            let con = UIGraphicsGetCurrentContext()!
            con.setShadow(offset: CGSize(7, 7), blur: 12)

            if #available(iOS 10.0, *) {
                self.arrow.draw(at:CGPoint(0,0))
            } else {
                // Fallback on earlier versions
            }
            for _ in 0..<3 {
                con.translateBy(x: 20, y: 100)
                con.rotate(by: 30 * .pi/180.0)
                con.translateBy(x: -20, y: -100)
                if #available(iOS 10.0, *) {
                    self.arrow.draw(at:CGPoint(0,0))
                } else {
                    // Fallback on earlier versions
                }
            }

        case 9:
            let con = UIGraphicsGetCurrentContext()!
            con.setShadow(offset: CGSize(7, 7), blur: 12)

            con.beginTransparencyLayer(auxiliaryInfo: nil)
            if #available(iOS 10.0, *) {
                self.arrow.draw(at:CGPoint(0,0))
            } else {
                // Fallback on earlier versions
            }
            for _ in 0..<3 {
                con.translateBy(x: 20, y: 100)
                con.rotate(by: 30 * .pi/180.0)
                con.translateBy(x: -20, y: -100)
                if #available(iOS 10.0, *) {
                    self.arrow.draw(at:CGPoint(0,0))
                } else {
                    // Fallback on earlier versions
                }
            }
            con.endTransparencyLayer()


        default: break
        }
    }

}
