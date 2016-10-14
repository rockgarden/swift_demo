//
//  File.swift
//
//  Created by SunSet on 14-6-23.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.


import UIKit
class RefreshFooterView: RefreshBaseView {

	class func footer() -> RefreshFooterView {
		let footer: RefreshFooterView = RefreshFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
			height: CGFloat(RefreshViewHeight)))
		return footer
	}

	var lastRefreshCount: Int = 0

	override func layoutSubviews() {
		super.layoutSubviews()
		self.statusLabel.frame = self.bounds;
	}

	override func willMove(toSuperview newSuperview: UIView!) {
		super.willMove(toSuperview: newSuperview)
		if (self.superview != nil) {
			self.superview!.removeObserver(self, forKeyPath: RefreshContentSize as String, context: nil)
		}
		if (newSuperview != nil) {
			newSuperview.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
			// 重新调整frame
			adjustFrameWithContentSize()
		}
	}

	// 重写调整frame
	func adjustFrameWithContentSize() {
		let contentHeight: CGFloat = self.scrollView.contentSize.height//
		let scrollHeight: CGFloat = self.scrollView.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom
		var rect: CGRect = self.frame;
		rect.origin.y = contentHeight > scrollHeight ? contentHeight : scrollHeight
		self.frame = rect;
	}

	// 监听UIScrollView的属性
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if (!self.isUserInteractionEnabled || self.isHidden) {
			return
		}
		if RefreshContentSize.isEqual(to: keyPath!) {
			adjustFrameWithContentSize()
		} else if RefreshContentOffset.isEqual(to: keyPath!) {
			if self.State == RefreshState.refreshing {
				return
			}
			adjustStateWithContentOffset()
		}
	}


	func adjustStateWithContentOffset()
	{
		let currentOffsetY: CGFloat = self.scrollView.contentOffset.y
		let happenOffsetY: CGFloat = self.happenOffsetY()
		if currentOffsetY <= happenOffsetY {
			return
		}
		if self.scrollView.isDragging {
			let normal2pullingOffsetY = happenOffsetY + self.frame.size.height
			if self.State == RefreshState.normal && currentOffsetY > normal2pullingOffsetY {
				self.State = RefreshState.pulling;
			} else if (self.State == RefreshState.pulling && currentOffsetY <= normal2pullingOffsetY) {
				self.State = RefreshState.normal;
			}
		} else if (self.State == RefreshState.pulling) {
			self.State = RefreshState.refreshing
		}
	}


	override var State: RefreshState {

		willSet {
			if State == newValue {
				return;
			}
			oldState = State
			setState(newValue)
		}
		didSet {
			switch State {
			case .normal:
				self.statusLabel.text = RefreshFooterPullToRefresh as String;
				if (RefreshState.refreshing == oldState) {
//					self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
					UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
						self.scrollView.contentInset.bottom = self.scrollViewOriginalInset.bottom
					})
				} else {
					UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
//						self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
					})
				}
				let deltaH: CGFloat = self.heightForContentBreakView()
				let currentCount: Int = self.totalDataCountInScrollView()
				if (RefreshState.refreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount) {
					var offset: CGPoint = self.scrollView.contentOffset;
					offset.y = self.scrollView.contentOffset.y
					self.scrollView.contentOffset = offset;
				}
				break
			case .pulling:
				self.statusLabel.text = RefreshFooterReleaseToRefresh as String
				UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
//					self.arrowImage.transform = CGAffineTransformIdentity
				})
				break
			case .refreshing:
				self.statusLabel.text = RefreshFooterReleaseToRefresh as String;
				self.lastRefreshCount = self.totalDataCountInScrollView();
				UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
					var bottom: CGFloat = self.frame.size.height + self.scrollViewOriginalInset.bottom
					let deltaH: CGFloat = self.heightForContentBreakView()
					if deltaH < 0 {
						bottom = bottom - deltaH
					}
					var inset: UIEdgeInsets = self.scrollView.contentInset;
					inset.bottom = bottom;
					self.scrollView.contentInset = inset;
				})
				break
			default:
				break
			}
		}
	}


	func totalDataCountInScrollView() -> Int
	{
		var totalCount: Int = 0
		if self.scrollView is UITableView {
			let tableView: UITableView = self.scrollView as! UITableView
			for i in 0 ..< tableView.numberOfSections {
				totalCount = totalCount + tableView.numberOfRows(inSection: i)
			}
		} else if self.scrollView is UICollectionView {
			let collectionView: UICollectionView = self.scrollView as! UICollectionView
			for i in 0 ..< collectionView.numberOfSections {
				totalCount = totalCount + collectionView.numberOfItems(inSection: i)
			}
		}
		return totalCount
	}


	func heightForContentBreakView() -> CGFloat
	{
		let h: CGFloat = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
		return self.scrollView.contentSize.height - h;
	}


	func happenOffsetY() -> CGFloat
	{
		let deltaH: CGFloat = self.heightForContentBreakView()
		if deltaH > 0 {
			return deltaH - self.scrollViewOriginalInset.top;
		} else {
			return -self.scrollViewOriginalInset.top;
		}
	}


	func addState(_ state: RefreshState) {
		self.State = state
	}

}
