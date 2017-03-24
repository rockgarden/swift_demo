//
//  SeamlessScrollingHeaderViewController.swift
//  SeamlessScrollingHeaderView
//

/*:
 Use: https://github.com/KoheiHayakawa/KHATableViewWithSeamlessScrollingHeaderView/blob/master/README.md
 SubClass
 override func headerViewInView(_ view: SeamlessScrollingHeaderViewController) -> UIView {
 return UINib(nibName: "", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
 }
 */

import UIKit

public protocol SeamlessScrollingHeaderViewDataSource {
    func headerViewInView(_ view: SeamlessScrollingHeaderViewController) -> UIView
}

open class SeamlessScrollingHeaderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SeamlessScrollingHeaderViewDataSource {

    open var tableView: UITableView!
    open var headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

    open var navigationBarBackgroundColor = UIColor.white
    open var navigationBarTitleColor = UIColor.black
    open var navigationBarShadowColor = UIColor.lightGray
    open var statusBarStyle = UIApplication.shared.statusBarStyle

    fileprivate let previousStatusBarStyle = UIApplication.shared.statusBarStyle

    override open func viewDidLoad() {
        headerView = headerViewInView(self)

        super.viewDidLoad()

        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        let headerViewHeight = headerView.frame.size.height

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.black

        headerView.translatesAutoresizingMaskIntoConstraints = false

        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.size.height - 90, 0, 0, 0)
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(headerView.frame.size.height - 90, 0, 0, 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        view.addSubview(headerView)

        view.addConstraints([
            NSLayoutConstraint(
                item: tableView,
                attribute: .left,
                relatedBy: .equal,
                toItem: view,
                attribute: .left,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: tableView,
                attribute: .right,
                relatedBy: .equal,
                toItem: view,
                attribute: .right,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: tableView,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: tableView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: view,
                attribute: .bottom,
                multiplier: 1,
                constant: 0)]
        )

        view.addConstraints([
            NSLayoutConstraint(
                item: headerView,
                attribute: .left,
                relatedBy: .equal,
                toItem: view,
                attribute: .left,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: headerView,
                attribute: .right,
                relatedBy: .equal,
                toItem: view,
                attribute: .right,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(
                item: headerView,
                attribute: .top,
                relatedBy: .equal,
                toItem: view,
                attribute: .top,
                multiplier: 1,
                constant: statusBarHeight+navBarHeight),
            NSLayoutConstraint(
                item: headerView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: headerViewHeight)]
        )
    }

    override open func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = statusBarStyle
    }

    override open func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = previousStatusBarStyle
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    open
    func headerViewInView(_ view: SeamlessScrollingHeaderViewController) -> UIView {
        return headerView
    }


    // MARK: - UIScrollViewDelegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        let headerViewHeight = headerView.bounds.size.height
        let tableViewOriginY = statusBarHeight + navBarHeight + headerViewHeight

        if tableView.contentOffset.y + tableViewOriginY <= 0 {
            headerView.frame = CGRect(x: headerView.bounds.origin.x,
                                      y: statusBarHeight + navBarHeight,
                                      width: headerView.bounds.size.width,
                                      height: headerView.bounds.size.height)
//            headerView.constraints[0].constant = statusBarHeight + navBarHeight
//            view.updateConstraints()
            setColorWithAlpha(0.0)
        } else {
            headerView.frame = CGRect(x: headerView.bounds.origin.x,
                                      y: -(tableView.contentOffset.y + headerViewHeight),
                                      width: headerView.bounds.size.width,
                                      height: headerViewHeight)
//            headerView.constraints[0].constant = -(tableView.contentOffset.y + headerViewHeight)
//            view.updateConstraints()
            let alpha = (tableView.contentOffset.y + tableViewOriginY) / tableViewOriginY
            setColorWithAlpha(alpha)
        }
    }


    // MARK: - Color handler

    /*! Seemlessly transparenting three colors of navbar background, navbar shadow and navbar title
     */
    fileprivate func setColorWithAlpha(_ alpha: CGFloat) {
        let alphaForNavBar = 8 * (alpha - 0.5)
        headerView.alpha = 1 - 3 * alpha
        self.navigationController?.navigationBar.setBackgroundImage(self.colorImage(navigationBarBackgroundColor.withAlphaComponent(alphaForNavBar), size: CGSize(width: 1, height: 1)), for: .default)
        self.navigationController?.navigationBar.shadowImage = self.colorImage(navigationBarShadowColor.withAlphaComponent(alphaForNavBar), size: CGSize(width: 1, height: 1))
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: navigationBarTitleColor.withAlphaComponent(alphaForNavBar)]
    }

    /*! Create UIImage from UIColor
     */
    fileprivate func colorImage(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }


    // MARK: - UITableViewDataSource

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        return cell
    }
}
