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

import Foundation
import UIKit

// The game.
// Each image has two versions "A" and "B"
// For any round one animal is chosen with 3x of either or A and 1x of the other, in a random order

private enum Version: String {
  case A = "A"
  case B = "B"
}

// The animal images
private enum Animal: Int {

  case bear, cat, frog, wolf


  static func random() -> Animal {
    let randomInt = Int(arc4random_uniform(4))
    return Animal(rawValue: randomInt)!
  }

  // Build the image for a particular version + animal
  func imageForVersion(_ version: Version) -> UIImage {
    let baseName: String
    switch self {
    case .bear:
      baseName = "Bear"
    case .cat:
      baseName = "Cat"
    case .frog:
      baseName = "Frog"
    case .wolf:
      baseName = "Wolf"
    }

    let imageName = baseName + version.rawValue
    return UIImage(named: imageName)!
  }
}

class MatchingGame {

  let numberOfImages = 4 // number of image views to show

  var currentRound = 0
  var maxRounds = 4 // number of rounds in the game, set to Inf to never end
  var score = 0 // number of correct guesses

  var differentLocation = 0

  func reset() {
    score = 0
    currentRound = 0
  }

  // create a set of images, randomly chosen animal, randomly chosen different version in a random position
  func getImages() -> [UIImage] {
    let imageType = Animal.random()

    let dominant: Version = arc4random_uniform(2) == 0 ? .A : .B
    let different: Version = dominant == .A ? .B : .A

    differentLocation = Int(arc4random_uniform(UInt32(numberOfImages)))

    var images = [UIImage]()

    for i in 0..<numberOfImages {
      let version = i == differentLocation ? different : dominant
      let image = imageType.imageForVersion(version)
      images.append(image)
    }

    // game state

    currentRound += 1
    return images
  }

  // find out if the guessed image was the different one
  // return if that guess was correct, and a flag if that was the last round
  func didUserWin(_ selectedIndex: Int) -> (won: Bool, correctIndex: Int, gameOver: Bool) {
    let won = selectedIndex == differentLocation
    if won {
      score += 1
    }

    let gameOver = currentRound == maxRounds

    return (won, differentLocation, gameOver)
  }
}
