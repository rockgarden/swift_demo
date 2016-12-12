//
//  HelpSectionHeader.swift
//  TableViewSpread-swift
//
//  Created by pxh on 2016/11/18.
//  Copyright © 2016年 pxh. All rights reserved.
//

import UIKit

typealias callBackBlock = (_ index : NSInteger,_ isSelected : Bool)->()

class SectionHeader: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spreadBtn: UIButton!    
    var spreadBlock : callBackBlock!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        let subView = Bundle.main.loadNibNamed("SectionHeader", owner: self, options: nil)?.first as! UIView
        subView.frame = self.frame
        self.addSubview(subView)
        spreadBtn.tintColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func spreadBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let _ = spreadBlock{
            spreadBlock(self.tag, sender.isSelected)
        }
    }

}
