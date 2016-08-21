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

// To be shown at the end of the game with the final score
class GameOverViewController: UIViewController {

  @IBOutlet weak var scoreLabel: UILabel!
  var game: MatchingGame!


  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    let score = game.score
    let total = game.currentRound

    let largeFont = UIFont.systemFontOfSize(32)
    let scoreStr = NSMutableAttributedString(string: "\(score)", attributes: [NSFontAttributeName : largeFont])
    let totalStr = NSMutableAttributedString(string: "\(total)", attributes: [NSFontAttributeName : largeFont])
    let mainStr = NSAttributedString(string: " out of ", attributes: nil)
    scoreStr.appendAttributedString(mainStr)
    scoreStr.appendAttributedString(totalStr)
    scoreLabel.attributedText = scoreStr
  }

  // let the user start a new game
  @IBAction func playAgain(sender: AnyObject) {
    game.reset()
    dismissViewControllerAnimated(true, completion: nil)
  }

}
