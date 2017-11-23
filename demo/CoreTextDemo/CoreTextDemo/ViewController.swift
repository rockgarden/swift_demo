//
//  ViewController.swift
//  CoreTextDemo
//
//  https://www.raywenderlich.com/153591/core-text-tutorial-ios-making-magazine-app
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }
        
        do {
            let text = try String(contentsOfFile: file, encoding: .utf8)
            // 2
            let parser = MarkupParser()
            parser.parseMarkup(text)
            (view as? CTView)?.buildFrames(withAttrString: parser.attrString, andImages: parser.images)
            
        } catch _ {
        }
    }
    
}

