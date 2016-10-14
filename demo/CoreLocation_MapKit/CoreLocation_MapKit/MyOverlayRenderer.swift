

import UIKit
import MapKit

class MyOverlayRenderer: MKOverlayRenderer {
	var angle: CGFloat = 0

	init(overlay: MKOverlay, angle: CGFloat) {
		self.angle = angle
		super.init(overlay: overlay)
	}

	override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
		// print isn't thread-safe
		// MKStringFromMapRect isn't available in Swift
		let s = "\(mapRect.origin.x) \(mapRect.origin.y) \(mapRect.size.width) \(mapRect.size.height)"
		NSLog("draw this: %@", s)
		context.setStrokeColor(UIColor.black.cgColor)
		context.setFillColor(UIColor.red.withAlphaComponent(0.2).cgColor)
		context.setLineWidth(1.2 / zoomScale)

		let unit = CGFloat(MKMapRectGetWidth(self.overlay.boundingMapRect) / 4.0)

		let p = CGMutablePath()
		let start = CGPoint(x: 0, y: unit * 1.5)
		let p1 = CGPoint(x: start.x + 2 * unit, y: start.y)
		let p2 = CGPoint(x: p1.x, y: p1.y - unit)
		let p3 = CGPoint(x: p2.x + unit * 2, y: p2.y + unit * 1.5)
		let p4 = CGPoint(x: p2.x, y: p2.y + unit * 3)
		let p5 = CGPoint(x: p4.x, y: p4.y - unit)
		let p6 = CGPoint(x: p5.x - 2 * unit, y: p5.y)
		let points = [
			start, p1, p2, p3, p4, p5, p6
		]
		// rotate the arrow around its center
		let t1 = CGAffineTransform(translationX: unit * 2, y: unit * 2)
		let t2 = t1.rotated(by: self.angle)
		let t3 = t2.translatedBy(x: -unit * 2, y: -unit * 2)
		// passing a Swift array of CGPoint where C expects a pointer to C array of CGPoint just works
        p.addLines(between: points, transform: t3)
		p.closeSubpath()

		context.addPath(p)
		context.drawPath(using: .fillStroke)
	}
}

