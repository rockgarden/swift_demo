//
//  ViewController.swift
//  CoreGraphicsDemo
//
//  Created by wangkan on 2017/5/11.
//  Copyright © 2017年 rockgarden. All rights reserved.
//


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //gridLayout()
        //gridLayoutWithPadding()
        gridLayoutByOOP()
    }


    // 生成小网格
    private func addGrid(_ rect: CGRect) {
        let gridView = UIView(frame: rect)
        gridView.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        gridView.layer.borderColor = UIColor.gray.cgColor
        gridView.layer.borderWidth = 0.5
        view.addSubview(gridView)
    }

    // FIXME: NO 网格布局
    func gridLayout() {
        let gridWidth:      CGFloat   = 40
        let gridHeight:     CGFloat   = 30
        let numberOfRow = Int(floor((view.bounds.size.height-20)/gridHeight))
        let numberOfColumn = Int(floor((view.bounds.size.width)/gridWidth))
        //var slice:          CGRect    = CGRect.zero
        let rowReminder = CGRect(x: 0, y: 20, width: view.bounds.size.width, height: view.bounds.size.height-20)
        var columnReminder = CGRect.zero
        // 行
        for _ in 0 ..< numberOfRow {
            let (slice, _) = rowReminder.divided(atDistance: gridHeight, from: .minYEdge)
            columnReminder = slice
            // 列
            for _ in 0 ..< numberOfColumn {
                let (slice, _) = columnReminder.divided(atDistance: gridHeight, from: .minXEdge)
                addGrid(slice)
            }
        }
    }

    private func rectDividedWithPading(_ rect: CGRect, slice: UnsafeMutablePointer<CGRect>, reminder: UnsafeMutablePointer<CGRect>, amout: CGFloat, padding: CGFloat, edge: CGRectEdge) {
        //let rect = rect
        let (_, _) = rect.divided(atDistance: amout, from: edge)
        //CGRectDivide(rect, slice, &rect, amout, edge)
        //var tmpSlice: CGRect = CGRect.zero
        let (_, _) = rect.divided(atDistance: padding, from: edge)
        //CGRectDivide(rect, &tmpSlice, reminder, padding, edge)
    }

    // 带padding的网格布局
    func gridLayoutWithPadding() {
        let paddingX:       CGFloat   = 3
        let paddingY:       CGFloat   = 5
        let gridWidth:      CGFloat   = 40
        let gridHeight:     CGFloat   = 30
        let numberOfRow:    NSInteger = NSInteger(floor((view.bounds.size.height-20)/gridHeight))
        let numberOfColumn: NSInteger = NSInteger(floor((view.bounds.size.width)/gridWidth))
        var slice:          CGRect    = CGRect.zero
        var rowReminder:    CGRect    = CGRect(x: 0, y: 20, width: view.bounds.size.width, height: view.bounds.size.height-20)
        var columnReminder: CGRect    = CGRect.zero
        // 行
        for _ in 0 ..< numberOfRow {
            rectDividedWithPading(rowReminder, slice: &slice, reminder: &rowReminder, amout: gridHeight, padding: paddingY, edge: .minYEdge)
            columnReminder = slice
            // 列
            for _ in 0 ..< numberOfColumn {
                rectDividedWithPading(columnReminder, slice: &slice, reminder: &columnReminder, amout: gridWidth, padding: paddingX, edge: .minXEdge)
                addGrid(slice)
            }
        }
    }

    // 利用面向对象的方式来使用CGRectDivide
    func gridLayoutByOOP() {

        let paddingX:       CGFloat   = 3
        let paddingY:       CGFloat   = 5
        let gridWidth:           CGFloat     = 40
        let gridHeight:          CGFloat     = 30
        let numberOfRow         = Int(floor((view.bounds.size.height-20)/gridHeight))
        let numberOfColumn      = Int(floor((view.bounds.size.width)/gridWidth))
        var horizontalRectModel = CGRectModel(rect: CGRect(x: 0, y: 20, width: view.bounds.size.width, height: view.bounds.size.height-20))
        var verticalRectModel:   CGRectModel

        /*网格布局*/
        // 行
        for _ in 0 ..< numberOfRow {
            let tmpTuple = horizontalRectModel.divided(gridHeight, edge: .minYEdge)
            horizontalRectModel = CGRectModel(rect: tmpTuple.reminder)
            verticalRectModel = CGRectModel(rect: tmpTuple.slice)
            // 列
            for _ in 0 ..< numberOfColumn {
                let tuple = verticalRectModel.divided(gridWidth, edge: .minXEdge)
                verticalRectModel = CGRectModel(rect: tuple.reminder)
                addGrid(tuple.slice)
            }
        }

        /*带padding的网格布局*/
        // 行
        for _ in 0 ..< numberOfRow {
            let tmpTuple = horizontalRectModel.dividedWithPadding(paddingY, amout: gridHeight, edge: .minYEdge)
            horizontalRectModel = CGRectModel(rect: tmpTuple.reminder)
            verticalRectModel = CGRectModel(rect: tmpTuple.slice)
            // 列
            for _ in 0 ..< numberOfColumn {
                let tuple = verticalRectModel.dividedWithPadding(paddingX, amout: gridWidth, edge: .minXEdge)
                verticalRectModel = CGRectModel(rect: tuple.reminder)
                //addGrid(tuple.slice)
            }
        }
    }
    
}

