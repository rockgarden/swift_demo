//
//  CardStyleTableView.swift
//  CardStyleTableView
//
//  Created by Xin Hong on 16/1/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import MJRefresh

class CardStyleTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var numberRows:Int = 50
    var changeContentSize:((_ contentSize:CGSize)->())?
    
    convenience init() {
        self.init()
        self.delegate = self
        self.dataSource = self
        self.cardStyleSource = self
        self.rowHeight = CGFloat((1000 - 140) / 20);
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.mj_header = MJRefreshNormalHeader { [weak self] in
            guard let weak = self else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                weak.mj_header.endRefreshing()
                weak.reloadData()
            })
        }
        
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func loadeMoreData() {
        self.numberRows += 10
        self.reloadData()
        self.changeContentSize?(self.contentSize)
    }
    
    func setScrollViewContentOffSet(point:CGPoint) {
        if !self.mj_header.isRefreshing() {
            self.contentOffset = point
        }
    }
    
    //UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = "\(indexPath.row) - reusablecell"
            return cell
        } else {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = "\(indexPath.row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberRows
    }
}


extension CardStyleTableView: CardStyleTableViewStyleSource {
    func roundingCornersForCard(inSection section: Int) -> UIRectCorner {
        return [.allCorners]
    }
    
    func leftPaddingForCardStyleTableView() -> CGFloat {
        return 10
    }
    
    func rightPaddingForCardStyleTableView() -> CGFloat {
        return 10
    }
    
    func cornerRadiusForCardStyleTableView() -> CGFloat {
        return 6
    }
}


extension UITableView {
    // MARK: - Properties
    public var cardStyleSource: CardStyleTableViewStyleSource? {
        get {
            let container = objc_getAssociatedObject(self, &AssociatedKeys.cardStyleTableViewStyleSource) as? WeakObjectContainer
            return container?.object as? CardStyleTableViewStyleSource
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.cardStyleTableViewStyleSource, WeakObjectContainer(object: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal var leftPadding: CGFloat? {
        return cardStyleSource?.leftPaddingForCardStyleTableView()
    }
    
    internal var rightPadding: CGFloat? {
        return cardStyleSource?.rightPaddingForCardStyleTableView()
    }

    // MARK: - Initialize
    open override class func initialize() {
        if self != UITableView.self {
            return
        }
        cardStyle_swizzleTableViewLayoutSubviews
    }

    // MARK: - Method swizzling
    func cardStyle_tableViewSwizzledLayoutSubviews() {
        cardStyle_tableViewSwizzledLayoutSubviews()
        updateSubviews()
    }

    fileprivate static let cardStyle_swizzleTableViewLayoutSubviews: () = {
        let originalSelector = TableViewSelectors.layoutSubviews
        let swizzledSelector = TableViewSelectors.swizzledLayoutSubviews

        let originalMethod = class_getInstanceMethod(UITableView.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UITableView.self, swizzledSelector)

        let didAddMethod = class_addMethod(UITableView.self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

        if didAddMethod {
            class_replaceMethod(UITableView.self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        print("cardStyle_swizzleTableViewLayoutSubviews")
    }()

    // MARK: - Helper
    fileprivate func updateSubviews() {
        guard let leftPadding = leftPadding, let rightPadding = rightPadding, style == .grouped && cardStyleSource != nil else {
            return
        }

        for subview in subviews {
            if String(describing: type(of: subview)) == "UITableViewWrapperView" {
                if subview.frame.origin.x != leftPadding {
                    subview.frame.origin.x = leftPadding
                }
                if subview.frame.width != frame.width - leftPadding - rightPadding {
                    subview.frame.size.width = frame.width - leftPadding - rightPadding
                }
            }
            if subview is UITableViewHeaderFooterView {
                if subview.frame.origin.x != leftPadding {
                    subview.frame.origin.x = leftPadding
                }
                if subview.frame.width != frame.width - leftPadding - rightPadding {
                    subview.frame.size.width = frame.width - leftPadding - rightPadding
                }
            }
        }
    }
}
