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
import UIKit.UIGestureRecognizerSubclass // UIGestureRecognizerSubclass 是 UIKit 中的一个公共头文件，但是没有包含在 UIKit 头文件中。因为你需要更新 state 属性，所以导入这个头文件是必须的，否则， 它就只是 UIGestureRecognizer 中的一个只读属性。

class CircleGestureRecognizer: UIGestureRecognizer {

	private var touchedPoints = [CGPoint]() // point history
	var fitResult = CircleResult() // information about how circle-like is the path 路径类圆的判断结果
	var tolerance: CGFloat = 0.2 // circle wiggle room 圆的容错值
	var isCircle = false
	var path = CGPathCreateMutable() // running CGPath - helps with drawing 运行 CGPath - 辅助绘制

	/**
	 当手势识别器的状态改变时它的 target-action 就会被触发:
	 当手指触碰到屏幕时,touchesBegan(_:withEvent) 触发.手势识别器将其状态置为 .Began,然后自动调用 target-action。

	 - parameter touches: <#touches description#>
	 - parameter event:   <#event description#>
	 */
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesBegan(touches, withEvent: event)
		if touches.count != 1 { // touches参数=1只允许包含一个 UITouch 对象
			state = .Failed
		}
		state = .Began

		let window = view?.window
		if let touches = touches as? Set<UITouch>, loc = touches.first?.locationInView(window) {
			CGPathMoveToPoint(path, nil, loc.x, loc.y) // start the path 绘制辅助线
		}
	}

	/**
	 当手势识别器的状态改变时它的 target-action 就会被触发:
	 当手指离开屏幕时,touchesEnded(_:withEvent) 将其状态置为 .Ended,然后再次调用 target-action

	 - parameter touches: <#touches description#>
	 - parameter event:   <#event description#>
	 */
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event)

		// now that the user has stopped touching, figure out if the path was a circle
		fitResult = fitCircle(touchedPoints)

		// make sure there are no points in the middle of the circle 保证没有点在圆的中间
		let hasInside = anyPointsInTheMiddle()

		let percentOverlap = calculateBoundingOverlap()
		// error 值代表了目前的路径和真正的圆形偏离了多少，而tolerance的存在则是因为你不能期望用户能画出一个完美的圆。如果error的值在tolerance的范围内，手势识别器将状态置为.Ended；否则将状态置为.Failed。
		isCircle = fitResult.error <= tolerance && !hasInside && percentOverlap > (1 - tolerance)

		state = isCircle ? .Ended : .Failed
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesMoved(touches, withEvent: event)

		// 1
		if state == .Failed {
			return
		}

		// 2
		let window = view?.window
		if let touches = touches as? Set<UITouch>, loc = touches.first?.locationInView(window) {
			// 3
			touchedPoints.append(loc)
			CGPathAddLineToPoint(path, nil, loc.x, loc.y)
			// 4
			state = .Changed
		}
	}

  /**
   手势识别器的状态机引入新的动作：reset() 复位动作, touchesEnded 之后 touchesBegan 之前调用 reset() 。这可以让手势识别器清除它的状态然后重新开始。
   called automatically by the runtime after the gesture state has been set to UIGestureRecognizerStateEnded
   */
	override func reset() {
		super.reset()
		touchedPoints.removeAll(keepCapacity: true)
		path = CGPathCreateMutable()
		isCircle = false
		state = .Possible //状态设置为 .Possible
	}

  /**
   检查圆内部
   对于像类似S，漩涡，数字8等等对称的形状。拟合得到的误差非常小，但是很显然它们都不是圆。
   这就是数学近似法和一个可用手势之间的差距。
   一个明显的修复方式就是排除所有在圆内部存在点的路径。

   这段代码对根据圆拟合出来的一个较小矩形禁区进行检查。如果有某个点出现在这个矩形中那么这个手势就失效了。上述代码做了如下的事情：
   计算出一个较小的禁区。变量tolerance 将为散乱，但合理的圆提供足够的空间，但是也有足够的控件来排除那些正中间有点的非圆形状。
   为了简化代码，这段代码只是在圆心构建了一个小方块。
   这段代码会遍历所有的点，然后检查是否有点在 innerBox 内。
   - returns: <#return value description#>
   */
	private func anyPointsInTheMiddle() -> Bool {
		// 1
		let fitInnerRadius = fitResult.radius / sqrt(2) * tolerance
		// 2
		let innerBox = CGRect(
			x: fitResult.center.x - fitInnerRadius,
			y: fitResult.center.y - fitInnerRadius,
			width: 2 * fitInnerRadius,
			height: 2 * fitInnerRadius)

		// 3
		var hasInside = false
		for point in touchedPoints {
			if innerBox.contains(point) {
				hasInside = true
				break
			}
		}

		return hasInside
	}

  /**
   把路径的大小和拟合圆的大小做比较
   这个方法计算出用户的路径和拟合圆有多少是重叠的：
   找出拟合圆和用户路径的包围盒。因为所有的触摸点都被做为 CGMutablePath 路径变量的一部分，所以可以使用 CGPathGetBoundingBox 方法来处理棘手的数学问题。
   使用 CGRect 的 rectByIntersecting 方法来计算出两个矩形路径的重叠部分。
   找出两个包围盒面积重叠部分的百分比。如果是一个良好的圆形手势，那么这个百分比会在80%-100%的范围内。在短弧的情况下，这个百分比会非常非常小！
   - returns: <#return value description#>
   */
	private func calculateBoundingOverlap() -> CGFloat {
		// 1
		let fitBoundingBox = CGRect(
			x: fitResult.center.x - fitResult.radius,
			y: fitResult.center.y - fitResult.radius,
			width: 2 * fitResult.radius,
			height: 2 * fitResult.radius)
		let pathBoundingBox = CGPathGetBoundingBox(path)

		// 2
		let overlapRect = fitBoundingBox.intersect(pathBoundingBox)

		// 3
		let overlapRectArea = overlapRect.width * overlapRect.height
		let circleBoxArea = fitBoundingBox.height * fitBoundingBox.width

		let percentOverlap = overlapRectArea / circleBoxArea
		return percentOverlap
	}

  /**
   处理Cancelled状态
   触摸会在有系统告警、在手势识别器被某个代理明确取消、在触摸中途被置为不可用时被取消掉。
   除了更新状态机，不需要为圆形识别器做更多的事情。
   - parameter touches: <#touches description#>
   - parameter event:   <#event description#>
   */
	override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
		super.touchesCancelled(touches, withEvent: event)
		state = .Cancelled // forward the cancel state 提前设置为取消状态
	}

}

