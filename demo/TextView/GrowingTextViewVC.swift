//
//  ViewController.swift
//  RSKGrowingTextViewExample
//
//  Created by Ruslan Skorb on 12/14/15.
//  Copyright © 2015 Ruslan Skorb. All rights reserved.
//


class GrowingTextViewVC: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var growingTextView: GrowingTextView!
    
    private var isVisibleKeyboard = true
    
    // MARK: - Object Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.unregisterForKeyboardNotifications()
    }
    
    // MARK: - Helper Methods
    
    private func adjustContent(for keyboardRect: CGRect) {
        let keyboardHeight = keyboardRect.height
        let keyboardYPosition = self.isVisibleKeyboard ? keyboardHeight : 0.0;
        self.bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint.constant = keyboardYPosition
        self.view.layoutIfNeeded()
    }
    
    @IBAction func handleTapGestureRecognizer(sender: UITapGestureRecognizer) {
        self.growingTextView.resignFirstResponder()
    }
    
    private func registerForKeyboardNotifications() {
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
            willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                self.isVisibleKeyboard = isShowing
                self.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                self.isVisibleKeyboard = isShown
            }
        )
        
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
        }, onComplete: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        self.unregisterForKeyboardNotifications()
    }
}

