/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

// special view to draw the circles
class CircleDrawView: UIView {

  override class var layerClass : AnyClass {
    return CAShapeLayer.self
  }

  fileprivate var path: CGPath?
  fileprivate var fitResult: CircleResult?
  fileprivate var isCircle = false

  var drawDebug = true // set to true show additional information about the fit 设置成true将展示拟合相关的其他信息

  func updateFit(_ fit: CircleResult?, madeCircle: Bool) {
    fitResult = fit
    isCircle = madeCircle
    setNeedsDisplay()
  }

  func updatePath(_ p: CGPath?) {
    path = p
    setNeedsDisplay()
  }

  func clear() {
    updateFit(nil, madeCircle: false)
    updatePath(nil)
  }

  override func draw(_ rect: CGRect) {
    if let path = path { // draw a thick yellow line for the user touch path
      let context = UIGraphicsGetCurrentContext()
      context?.addPath(path)
      context?.setStrokeColor(UIColor.yellow.cgColor)
      context?.setLineWidth(10)
      context?.setLineCap(CGLineCap.round)
      context?.setLineJoin(CGLineJoin.round)
      context?.strokePath()
    }

    if let fit = fitResult , drawDebug { // if there is a fit and drawDebug is turned on
      if !fit.error.isNaN { // if error has been defined, draw the fit
        let fitRect = CGRect(
          x: fit.center.x - fit.radius,
          y: fit.center.y - fit.radius,
          width: 2 * fit.radius,
          height: 2 * fit.radius
        )
        let fitPath = UIBezierPath(ovalIn: fitRect)
        fitPath.lineWidth = 3

        // fit is the circle (green if the circle matched, red was the fit circle but did not recognize as a circle)
        let circleColor = isCircle ? UIColor.green : UIColor.red
        circleColor.setStroke()
        fitPath.stroke()
      }

      // draw a black bounding box around the user touch path
      let boundingBox = UIBezierPath(rect: (path?.boundingBox)!)
      boundingBox.lineWidth = 1
      UIColor.black.setStroke()
      boundingBox.stroke()

      // draw a blue square inside as the touch exclusion area
      let fitInnerRadius = fit.radius / sqrt(2)
      let innerBoxRect = CGRect(
        x: fit.center.x - fitInnerRadius,
        y: fit.center.y - fitInnerRadius,
        width: 2 * fitInnerRadius,
        height: 2 * fitInnerRadius
      )
      let modifiedInnerBox = innerBoxRect.insetBy(dx: fitInnerRadius*0.2, dy: fitInnerRadius*0.2)

      let innerBox = UIBezierPath(rect: modifiedInnerBox)
      UIColor.blue.withAlphaComponent(0.5).setFill()
      innerBox.fill()
    }
  }
}
