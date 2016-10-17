

import UIKit

class MandelbrotOperation: Operation {
	fileprivate let size: CGSize
	fileprivate let center: CGPoint
	fileprivate let zoom: CGFloat
	fileprivate(set) var bitmapContext: CGContext! = nil

	init(size sz: CGSize, center c: CGPoint, zoom z: CGFloat) {
		self.size = sz
		self.center = c
		self.zoom = z
		super.init()
	}

	let MANDELBROT_STEPS = 200

	// create instance variable
	func makeBitmapContext(_ size: CGSize) {
		var bitmapBytesPerRow = Int(size.width * 4)
		bitmapBytesPerRow += (16 - (bitmapBytesPerRow % 16)) % 16
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let prem = CGImageAlphaInfo.premultipliedLast.rawValue
		let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: prem)
		self.bitmapContext = context
	}

	func drawAtCenter(_ center: CGPoint, zoom: CGFloat) {
		func isInMandelbrotSet(_ re: Float, _ im: Float) -> Bool {
			var fl = true
			var (x, y, nx, ny): (Float, Float, Float, Float) = (0, 0, 0, 0)
			for _ in 0 ..< MANDELBROT_STEPS {
				nx = x * x - y * y + re
				ny = 2 * x * y + im
				if nx * nx + ny * ny > 4 {
					fl = false
					break
				}
				x = nx
				y = ny
			}
			return fl
		}
		self.bitmapContext.setAllowsAntialiasing(false)
		self.bitmapContext.setFillColor(red: 0, green: 0, blue: 0, alpha: 1)
		var re: CGFloat
		var im: CGFloat
		let maxi = Int(self.size.width) // *
		let maxj = Int(self.size.height) // *
		for i in 0 ..< maxi {
			for j in 0 ..< maxj {
				re = (CGFloat(i) - 1.33 * center.x) / 160
				im = (CGFloat(j) - 1.0 * center.y) / 160

				re /= zoom
				im /= zoom

				if (isInMandelbrotSet(Float(re), Float(im))) {
					self.bitmapContext.fill (CGRect(x: CGFloat(i), y: CGFloat(j), width: 1.0, height: 1.0))
				}
			}
		}
	}

	override func main() {
		if self.isCancelled {
			return
		}
		self.makeBitmapContext(self.size)
		self.drawAtCenter(self.center, zoom: self.zoom)
		if !self.isCancelled {
			NotificationCenter.default.post(name: Notification.Name(rawValue: "MyMandelbrotOperationFinished"), object: self)
		}
	}

}
