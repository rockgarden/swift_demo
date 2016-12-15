//
//  ShapeView.swift
//  Draw
//

/*
 The Graphic Context is your graphic destination. If you want to draw on a view, the view is your Graphic Context. We need to get a reference  to the Graphics Context.
 A path is a set of lines, arcs and curves you can draw on the current graphic context to build complex objects. Here we draw some lines and set the line width to 5.
 The path is closed and drawn to the graphics context.
 With CGContextAddRect a rectangle is drawn. the outline stroke color is gray.
 Here the same rectangle is defined, with a fill color of green
 With CGContextAddArc a circle is drawn
 */

import UIKit

class ShapeView: UIView {
    var currentShapeType: Int = 0

    init(frame: CGRect, shape: Int) {
        super.init(frame: frame)
        self.currentShapeType = shape
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func draw(_ rect: CGRect) {
        switch currentShapeType {
        case 0: drawRectangle()
        case 1: drawLines()
        case 2: drawCircle()
        default: print("default")
        }
    }

    func drawLines() {
        //1 The Graphic Context is your graphic destination. If you want to draw on a view, the view is your Graphic Context. We need to get a reference to the Graphics Context.
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        //2 A path is a set of lines, arcs and curves you can draw on the current graphic context to build complex objects. Here we draw some lines and set the line width to 5.
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 20.0, y: 20.0))
        ctx.addLine(to: CGPoint(x: 250.0, y: 100.0))
        ctx.addLine(to: CGPoint(x: 100.0, y: 200.0))
        ctx.setLineWidth(5)

        //3 The path is closed and drawn to the graphics context.
        ctx.closePath()
        ctx.strokePath()
    }

    func drawRectangle() {
        let center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0)
        let rectangleWidth:CGFloat = 100.0
        let rectangleHeight:CGFloat = 100.0

        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        //4 With CGContextAddRect a rectangle is drawn. the outline stroke color is gray.
        ctx.addRect(CGRect(x: center.x - (0.5 * rectangleWidth), y: center.y - (0.5 * rectangleHeight), width: rectangleWidth, height: rectangleHeight))
        ctx.setLineWidth(10)
        ctx.setStrokeColor(UIColor.gray.cgColor)
        ctx.strokePath()

        ctx.setFillColor(UIColor.green.cgColor)

        //5 Here the same rectangle is defined, with a fill color of green
        ctx.addRect(CGRect(x: center.x - (0.5 * rectangleWidth), y: center.y - (0.5 * rectangleHeight), width: rectangleWidth, height: rectangleHeight))

        ctx.fillPath()
    }

    func drawCircle() {
        let center = CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0);

        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.beginPath()

        ctx.setLineWidth(5)

        let x:CGFloat = center.x
        let y:CGFloat = center.y
        let radius: CGFloat = 100.0
        let endAngle: CGFloat = CGFloat(2 * M_PI)

        //6 With CGContextAddArc a circle is drawn
        ctx.addArc(center: CGPoint(x: x,y: y), radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)

        ctx.strokePath()
    }


    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

}
