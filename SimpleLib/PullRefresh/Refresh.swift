//
//  Refresh.swift
//  PullRefresh
//
//  Created by SunSet on 14-6-25.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.


import Foundation

/*
 控件主要实现原理是监控scrollview的2个属性变化 来设置头部控件和尾部控件的状态
 通过扩展scrollView添加两个回调方法来实现刷新
 - scrollView.addHeaderWithCallback({})
 - scrollView.addFooterWithCallback({})
 */

/// RefreshConst
let RefreshViewHeight: CFloat = 64.0
let RefreshSlowAnimationDuration: TimeInterval = 0.2
let RefreshFooterPullToRefresh: NSString = "上拉可以加载更多数据"
let RefreshFooterReleaseToRefresh: NSString = "松开立即加载更多数据"
let RefreshFooterRefreshing: NSString = "正在加载数据..."
let RefreshHeaderPullToRefresh: NSString = "下拉可以刷新"
let RefreshHeaderReleaseToRefresh: NSString = "松开立即刷新"
let RefreshHeaderRefreshing: NSString = "正在刷新中..."
let RefreshHeaderTimeKey: NSString = "RefreshHeaderView"
let RefreshContentOffset: NSString = "contentOffset"
let RefreshContentSize: NSString = "contentSize"

/// ScrollView示例代码
//func setupRefresh() {
//    self.scrollView!.addHeaderWithCallback({
//        let delayInSeconds: Int64 = 1000000000 * 2
//        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.scrollView!.contentSize = self.view.frame.size
//            self.scrollView!.headerEndRefreshing()
//        })
//    })
//
//    self.scrollView!.addFooterWithCallback({
//        let delayInSeconds: Int64 = 1000000000 * 2
//        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            var size: CGSize = self.scrollView!.frame.size
//            size.height = size.height + 300
//            self.scrollView!.contentSize = size
//            self.scrollView!.footerEndRefreshing()
//        })
//    })
//}


/// TableView示例代码
//func setupRefresh() {
//    self.tableView.addHeaderWithCallback({
//        self.fakeData!.removeAllObjects()
//        self.fakeData!.addObject(Object)
//        let delayInSeconds: Int64 = 1000000000 * 2
//        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.tableView.reloadData()
//            self.tableView.headerEndRefreshing()
//        })
//
//    })
//
//    self.tableView.addFooterWithCallback({
//        self.fakeData!.addObject(Object)
//        let delayInSeconds: Int64 = 1000000000 * 2
//        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)
//        dispatch_after(popTime, dispatch_get_main_queue(), {
//            self.tableView.reloadData()
//            self.tableView.footerEndRefreshing()
//            //self.tableView.setFooterHidden(true)
//        })
//    })
//}
