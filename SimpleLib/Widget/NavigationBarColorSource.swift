//
//  NavigationBarColorSource.swift
//  MemoryInMap
//
//  Created by wangkan on 16/5/26.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import UIKit

@objc public protocol NavigationBarColorSource {
    @objc optional func navigationBarInColor() -> UIColor
    @objc optional func navigationBarOutColor() -> UIColor
}
