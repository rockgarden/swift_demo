//
//  MyCell.swift
//  StickyCollection
//
//  Created by Donny Wals on 01-06-15.
//  Copyright (c) 2015 Donny Wals. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell {
    
    @IBOutlet weak var headerTop: NSLayoutConstraint!
    
    override func prepareForReuse() {
        headerTop.constant = 0
    }
}