//
//  CirCleLayout.swift
//  ColloectionLayout
//
//  Created by jasnig on 16/6/12.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//  github: https://github.com/jasnig
//  简书: http://www.jianshu.com/p/b84f4dd96d0c

import UIKit

class CircleLayout: UICollectionViewLayout {
    fileprivate var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    // 圆心
    var center = CGPoint(x: 0.0, y: 0.0)
    // 圆半径
    var radius: CGFloat = 0.0
    var totalNum = 0
    override func prepare() {
        super.prepare()
        // 初始化需要的数据
        totalNum = collectionView!.numberOfItems(inSection: 0)
        // 每次计算前需要清零
        layoutAttributes = []
        center = CGPoint(x: Double(collectionView!.bounds.width * 0.5), y: Double(collectionView!.bounds.height * 0.5))
        radius = min(collectionView!.bounds.width, collectionView!.bounds.height) / 3.0

        var indexPath: IndexPath
        for index in 0..<totalNum {
            indexPath = IndexPath(row: index, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)!

            layoutAttributes.append(attributes)
        }
    }

    // 因为返回的collectionViewContentSize使得collectionView不能滚动, 所以当旋转的时候才会触发, 故返回为true便于重新计算布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    // Apple建议要重写这个方法, 因为某些情况下(delete insert...)系统可能需要调用这个方法来布局

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = CGSize(width: 60.0, height: 60.0)
        // 当前cell的角度
        // 注意类型转换
        let angle = 2 * CGFloat(M_PI) * CGFloat(indexPath.row) / CGFloat(totalNum)
        // 一点点数学转换
        attributes.center = CGPoint(x: center.x + radius*cos(angle), y: center.y + radius*sin(angle))
        return attributes
    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }

    override var collectionViewContentSize: CGSize { // change func to var
        return collectionView!.bounds.size
    }
}
