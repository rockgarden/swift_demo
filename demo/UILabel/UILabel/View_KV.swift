//
//  View_KV.swift
//  ICSLA
//
//  Created by wangkan on 2016/9/28.
//  Copyright © 2016年 eastcom. All rights reserved.
//
import UIKit

class View_KV: UIView {
    
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UITextView!
    
    static func newInstance() -> View_KV? {
        let nibView = NSBundle.mainBundle().loadNibNamed(String(self), owner: nil, options: nil)
        if let view = nibView.first as? View_KV {
            return view
        }
        return nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.value.layer.cornerRadius = 6.0
        self.value.layer.borderWidth = 2.0
        self.value.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    func configureItem(key: String, value: String) {
        self.key.text = key
        self.value.text = value
    }
}
