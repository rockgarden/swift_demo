//
//  RefreshBaseView.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-23.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.


import UIKit

/**
 刷新状态

 - Pulling:        松开就可以进行刷新的状态
 - Normal:         普通状态
 - Refreshing:     正在刷新中的状态
 - WillRefreshing: 将要刷新
 */
enum RefreshState {
	case Pulling
	case Normal
	case Refreshing
	case WillRefreshing
}

/**
 指示控件类型

 - TypeHeader: 头部控件
 - TypeFooter: 尾部控件
 */
enum RefreshViewType {
	case TypeHeader
	case TypeFooter
}

/// 提示文字颜色
let RefreshLabelTextColor: UIColor = UIColor(red: 150.0 / 255, green: 150.0 / 255.0, blue: 150.0 / 255.0, alpha: 1)


class RefreshBaseView: UIView {

	/// 父控件
	var scrollView: UIScrollView!
	var scrollViewOriginalInset: UIEdgeInsets!

	/// 内部的控件
	var statusLabel: UILabel!
	var activityView: UIActivityIndicatorView!

	/// 回调
	var beginRefreshingCallback: (() -> Void)?

	/// 保存状态参数
	var oldState: RefreshState?

	var State: RefreshState = RefreshState.Normal {
		willSet {
		}
		didSet {
		}
	}

    /**
     状态设置

     - parameter newValue: 新的状态
     */
	func setState(newValue: RefreshState) {
		if self.State != RefreshState.Refreshing {
			scrollViewOriginalInset = self.scrollView.contentInset;
		}
		if self.State == newValue {
			return
		}
		switch newValue {
		case .Normal:
			self.activityView.stopAnimating()
			break
		case .Pulling:
			break
		case .Refreshing:
			activityView.startAnimating()
			beginRefreshingCallback!()
			break
		default:
			break
		}
	}

    /**
     初始化

     - parameter frame
     */
	override init(frame: CGRect) {
		super.init(frame: frame)
		// 状态标签
		statusLabel = UILabel()
		statusLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
		statusLabel.font = UIFont.boldSystemFontOfSize(13)
		statusLabel.textColor = RefreshLabelTextColor
		statusLabel.backgroundColor = UIColor.clearColor()
		statusLabel.textAlignment = NSTextAlignment.Center
		self.addSubview(statusLabel)
		// 刷新状态指示器
		activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
		self.addSubview(activityView)

		self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
		self.backgroundColor = UIColor.clearColor()
		// 设置默认状态
		self.State = RefreshState.Normal;
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		// 设定指示器显示位置
		let viewX: CGFloat = self.frame.size.width * 0.5 - 100
        self.activityView.center = CGPointMake(viewX, self.frame.size.height * 0.5)
	}

	override func willMoveToSuperview(newSuperview: UIView!) {
		super.willMoveToSuperview(newSuperview)
		// 清除KVO
		if (self.superview != nil) {
			self.superview?.removeObserver(self, forKeyPath: RefreshContentSize as String, context: nil)
		}
		// 新的父控件
		if (newSuperview != nil) {
			newSuperview.addObserver(self, forKeyPath: RefreshContentOffset as String, options: NSKeyValueObservingOptions.New, context: nil)
			var rect: CGRect = self.frame
			// 设置宽度+位置
			rect.size.width = newSuperview.frame.size.width
			rect.origin.x = 0
			self.frame = frame;
			// UIScrollView
			scrollView = newSuperview as! UIScrollView
			scrollViewOriginalInset = scrollView.contentInset;
		}
	}

    /**
     显示到屏幕上

     - parameter rect: <#rect description#>
     */
	override func drawRect(rect: CGRect) {
		superview?.drawRect(rect);
		if self.State == RefreshState.WillRefreshing {
			self.State = RefreshState.Refreshing
		}
	}

    /**
     是否正在刷新

     - returns: Bool
     */
	func isRefreshing() -> Bool {
		return RefreshState.Refreshing == self.State;
	}

    /**
     开始刷新
     */
	func beginRefreshing() {
		if (self.window != nil) {
			self.State = RefreshState.Refreshing;
		} else {
			// 不能调用set方法
			State = RefreshState.WillRefreshing;
			super.setNeedsDisplay()
		}
	}

    /**
     结束刷新
     */
	func endRefreshing() {
		let delayInSeconds: Double = 0.2
		let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds));
		dispatch_after(popTime, dispatch_get_main_queue(), {
			self.State = RefreshState.Normal;
		})
	}
}

