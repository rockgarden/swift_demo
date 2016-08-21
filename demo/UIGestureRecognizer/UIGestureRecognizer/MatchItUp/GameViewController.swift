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

let afterGuessTimeout: NSTimeInterval = 2 // seconds

// border colors for image views
let successColor = UIColor(red: 80.0 / 255.0, green: 192.0 / 255.0, blue: 202.0 / 255.0, alpha: 1.0)
let failureColor = UIColor(red: 203.0 / 255.0, green: 85.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
let defaultColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)

/** The Main View Controller for the Game */
class GameViewController: UIViewController {
  
  var circleRecognizer: CircleGestureRecognizer!
  
  let game = MatchingGame()
  
  // The image views
  private var imageViews = [UIImageView]()
  @IBOutlet weak var image1: RoundedImageView!
  @IBOutlet weak var image2: RoundedImageView!
  @IBOutlet weak var image3: RoundedImageView!
  @IBOutlet weak var image4: RoundedImageView!
  
  // the game views
  @IBOutlet weak var gameButton: UIButton!
  @IBOutlet weak var circlerDrawer: CircleDrawView! // draws the user input
  
  var goToNextTimer: NSTimer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // put the views in an array to help with game logic
    imageViews = [image1, image2, image3, image4]
    
    // create and add the circle recognizer here
    circleRecognizer = CircleGestureRecognizer(target: self, action: #selector(circled(_:)))
    view.addGestureRecognizer(circleRecognizer) // 识别器添加到主视图
    
    circleRecognizer.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    startNewSet(view) // start the game
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    // clear any drawn circles when the view is rotated; this simplifies the drawing logic by not having to transform the coordinates and redraw the circle
    circlerDrawer.clear()
  }
  
  // MARK: - Game stuff
  
  // pick a new set of images, and reset the views
  @IBAction func startNewSet(sender: AnyObject) {
    goToNextTimer?.invalidate()
    
    circlerDrawer.clear()
    gameButton.setTitle("New Set!", forState: .Normal)
    gameButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    gameButton.backgroundColor = successColor
    
    imageViews.map { $0.layer.borderColor = defaultColor.CGColor }
    
    let images = game.getImages()
    for (index, image) in images.enumerate() {
      imageViews[index].image = image
    }
    
    circleRecognizer.enabled = true //让手势识别器重新生效
  }
  
  func goToGameOver() {
    performSegueWithIdentifier("gameOver", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "gameOver" {
      let gameOverViewController = segue.destinationViewController as! GameOverViewController
      gameOverViewController.game = game
    }
  }
  
  func selectImageViewAtIndex(guessIndex: Int) {
    
    // a view was selected - find out if it was the right one show the appropriate view states
    let selectedImageView = imageViews[guessIndex]
    let (won, correct, gameover) = game.didUserWin(guessIndex)
    
    if gameover {
      goToGameOver()
      return
    }
    
    let color: UIColor
    let title: String
    
    if won {
      title = "Correct!"
      color = successColor
    } else {
      title = "That wasn't it!"
      color = failureColor
    }
    
    selectedImageView.layer.borderColor = color.CGColor
    gameButton.setTitle(title, forState: .Normal)
    gameButton.backgroundColor = UIColor.clearColor()
    gameButton.setTitleColor(color, forState: .Normal)
    
    // stop any drawing and go to the next round after a timeout
    goToNextTimer?.invalidate() //添加了一个计时器，这个计时器会在短暂的延迟后清除掉路径，从而使用户在延迟时间内还能重新尝试。
    goToNextTimer = NSTimer.scheduledTimerWithTimeInterval(afterGuessTimeout, target: self, selector: #selector(startNewSet(_:)), userInfo: nil, repeats: false)
    
    circleRecognizer.enabled = false //图片被圈中之后阻止用户继续和视图交互。否则，在等待新一组图片出现时路径仍然会继续更新。
  }
  
  /**
   检测点击的是哪一张图片
   
   - parameter center: <#center description#>
   */
  func findCircledView(center: CGPoint) {
    // walk through the image views and see if the center of the drawn circle was over one of the views
    for (index, view) in imageViews.enumerate() {
      let windowRect = self.view.window?.convertRect(view.frame, fromView: view.superview)
      if windowRect!.contains(center) {
        print("Circled view # \(index)")
        selectImageViewAtIndex(index)
      }
    }
  }
  
  // MARK: - Circle Stuff
  
  /**
   手势处理
   
   - parameter c: <#c description#>
   */
  func circled(c: CircleGestureRecognizer) {
    if c.state == .Ended {
      findCircledView(c.fitResult.center)
    }
    if c.state == .Began {
      circlerDrawer.clear()
      goToNextTimer?.invalidate()
    }
    if c.state == .Changed {
      circlerDrawer.updatePath(c.path)
    }
    if c.state == .Ended || c.state == .Failed || c.state == .Cancelled {
      circlerDrawer.updateFit(c.fitResult, madeCircle: c.isCircle)
      goToNextTimer = NSTimer.scheduledTimerWithTimeInterval(afterGuessTimeout, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: false)
    }
  }
  
  /**
   计时器启动时清除圆形，这样用户就知道画另外一个圆形来再次尝试
   
   - parameter timer: <#timer description#>
   */
  func timerFired(timer: NSTimer) {
    circlerDrawer.clear()
  }
  
}

extension GameViewController: UIGestureRecognizerDelegate {
  /**
   阻止手势识别器去识别按钮上的触摸事件；而继续让按钮本身去处理触摸。
   
   - parameter gestureRecognizer: <#gestureRecognizer description#>
   - parameter touch:             <#touch description#>
   
   - returns: <#return value description#>
   */
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    // 允许点击按钮
    return !(touch.view is UIButton)
  }

}
