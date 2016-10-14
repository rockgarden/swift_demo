//
//  CustomCollectionLayout.swift
//  main
//
//  Created by wangkan on 16/6/29.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

/**
 * 这个类只简单定义了一个section的布局
 */
class CustomLayout : UICollectionViewLayout {

    // 内容区域总大小，不是可见区域
    override var collectionViewContentSize : CGSize {
        return CGSize(width: collectionView!.bounds.size.width,
                          height: CGFloat(collectionView!.numberOfItems(inSection: 0) * 200 / 3 + 200))
    }

    // 所有单元格位置属性
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var attributesArray = [UICollectionViewLayoutAttributes]()
            let cellCount = self.collectionView!.numberOfItems(inSection: 0)
            for i in 0..<cellCount {
                let indexPath =  IndexPath(item:i, section:0)

                let attributes =  self.layoutAttributesForItem(at: indexPath)

                attributesArray.append(attributes!)

            }
            return attributesArray
    }

    // 这个方法返回每个单元格的位置和大小
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            //当前单元格布局属性
            let attribute =  UICollectionViewLayoutAttributes(forCellWith:indexPath)

            //单元格外部空隙，简单起见，这些常量都在方法内部定义了，没有共享为类成员
            //let itemSpacing = 2
            let lineSpacing = 5

            //单元格边长
            let largeCellSide:CGFloat = 200
            let smallCellSide:CGFloat = 100

            //内部间隙，左右5
            let insets = UIEdgeInsetsMake(2, 5, 2, 5)

            //当前行数，每行显示3个图片，1大2小
            let line:Int =  (indexPath as NSIndexPath).item / 3
            //当前行的Y坐标
            let lineOriginY =  largeCellSide * CGFloat(line) + CGFloat(lineSpacing * line)
                + insets.top
            //右侧单元格X坐标，这里按左右对齐，所以中间空隙大
            let rightLargeX =  collectionView!.bounds.size.width - largeCellSide - insets.right
            let rightSmallX =  collectionView!.bounds.size.width - smallCellSide - insets.right

            // 每行2个图片，2行循环一次，一共6种位置
            if ((indexPath as NSIndexPath).item % 6 == 0) {
                attribute.frame = CGRect(x: insets.left, y: lineOriginY, width: largeCellSide,
                                             height: largeCellSide)
            } else if ((indexPath as NSIndexPath).item % 6 == 1) {
                attribute.frame = CGRect(x: rightSmallX, y: lineOriginY, width: smallCellSide,
                                             height: smallCellSide)
            } else if ((indexPath as NSIndexPath).item % 6 == 2) {
                attribute.frame = CGRect(x: rightSmallX,
                                             y: lineOriginY + smallCellSide + insets.top, width: smallCellSide, height: smallCellSide)
            } else if ((indexPath as NSIndexPath).item % 6 == 3) {
                attribute.frame = CGRect(x: insets.left, y: lineOriginY, width: smallCellSide,
                                             height: smallCellSide )
            } else if ((indexPath as NSIndexPath).item % 6 == 4) {
                attribute.frame = CGRect(x: insets.left,
                                             y: lineOriginY + smallCellSide + insets.top, width: smallCellSide, height: smallCellSide)
            } else if ((indexPath as NSIndexPath).item % 6 == 5) {
                attribute.frame = CGRect(x: rightLargeX, y: lineOriginY, width: largeCellSide,
                                             height: largeCellSide)
            }

            return attribute
    }
    
    /*
     //如果有页眉、页脚或者背景，可以用下面的方法实现更多效果
     func layoutAttributesForSupplementaryViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     func layoutAttributesForDecorationViewOfKind(elementKind: String!,
     atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
     */
}
