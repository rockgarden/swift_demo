//
//  KVOExampleVC.swift
//  KVO
//
//  Created by Bart Jacobs on 15/10/16.
//  Copyright © 2016 Cocoacasts. All rights reserved.
//

import UIKit

class KVOExampleVC: UIViewController {

    // MARK: - Properties
    @IBOutlet var timeLabel: UILabel!

    // MARK: -
    let configurationManager = ConfigurationManager(withConfiguration: Configuration())

    // MARK: - Deinitialization
    deinit {
        removeObserver(self, forKeyPath: #keyPath(configurationManager.configuration.updatedAt))
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Observer
        /// The first parameter is the object that is added as an observer. This can only be an instance of a class that inherits from the NSObject root class. It is the NSObject root class that defines the addObserver(_:forKeyPath:options:context:) method as well as the method that is invoked when a change is detected.
        /// Key Path
        /// The key path defines what property the observer is interested in. In the example, the view controller is added as an observer for the updatedAt property of the Configuration instance of the configuration manager of the view controller.
        /// Important: We use a #keyPath expression to define the key path. A key path is nothing more than a sequence of object properties. Before Swift 3, the key path was a string literal. Thanks to the addition of key path expressions, the compiler can check the validity of the key path at compile time. String literals don’t have this advantage, which often lead to bugs in the past.
        addObserver(self, forKeyPath: #keyPath(configurationManager.configuration.updatedAt), options: [.old, .new, .initial], context: nil)
        /// Notice that the key path used in addObserver(_:forKeyPath:options:context:) is relative to the current scope and context.
        /// new: This option ensures that the change dictionary includes the new value of the observed property.
        /// old: This option ensures that the change dictionary includes the old value of the observed property.
        /// initial: By including this option in the list of options, the observer is immediately sent a notification, before it is added as an observer.
        /// prior: This is an option you rarely use. This option ensures the observer receives a notification before and after a change occurs.
    }

    // MARK: - Actions
    @IBAction func updateConfiguration(sender: UIButton) {
        configurationManager.updateConfiguration()
    }

    // MARK: - Key-Value Observing
    /// Key Path:The first parameters is the key path that triggered the notification.
    /// Object: The observer is also given a reference to the object it is observing.
    /// Changes: The observer receives a dictionary of type [NSKeyValueChangeKey : Any]?. This dictionary can contain a number of key-value pairs. The contents depend on the options passed to addObserver(_:forKeyPath:options:context:).
    /// Context: This is the context that was passed in when the observer was added earlier.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(configurationManager.configuration.updatedAt) {
            // Update Time Label
            timeLabel.text = configurationManager.updatedAt
        }
    }

}
