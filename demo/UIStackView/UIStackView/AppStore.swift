//
//  AppStore.swift
//  UIStackView
//
//  Created by wangkan on 16/9/21.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class AppStore: UIViewController {

    let hostView = UIView(frame: CGRect(x: 0, y: 64, width: 320, height: 160))
    let makeView = { (color: UIColor) -> UIView in
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }

    convenience init(frame: CGRect) {
        self.init(nibName: nil, bundle: nil)
        title = "App Store"
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(hostView)
    }

    func setup() {
        hostView.backgroundColor = .white

        let iconImageView = UIImageView(image: UIImage(named: "IconFojusi"))
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true

        let appNameLabel = UILabel(frame: .zero)
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        appNameLabel.text = "Fojusi"
        appNameLabel.backgroundColor = .yellow

        let devNameLabel = UILabel(frame: .zero)
        devNameLabel.font = UIFont.systemFont(ofSize: 13)
        devNameLabel.text = "Dominik Hauser"
        devNameLabel.backgroundColor = .red

        let buyButton = UIButton(type: .system)
        buyButton.setTitle("0,99 €", for: UIControlState())
        buyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        buyButton.layer.cornerRadius = 5
        buyButton.layer.borderColor = buyButton.tintColor.cgColor
        buyButton.layer.borderWidth = 1

        let headerView = UIView(frame: .zero)
        //headerView.backgroundColor = UIColor.brownColor()

        let metaDataStackView = UIStackView(arrangedSubviews: [appNameLabel, devNameLabel])
        metaDataStackView.axis = .vertical

        let leftHeaderStackView = UIStackView(arrangedSubviews: [metaDataStackView, buyButton])
        leftHeaderStackView.axis = .vertical
        leftHeaderStackView.distribution = UIStackViewDistribution.equalCentering

        let headerStackView = UIStackView(arrangedSubviews: [iconImageView, leftHeaderStackView])
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        //  headerStackView.alignment = .Top
        headerStackView.isLayoutMarginsRelativeArrangement = true
        headerStackView.spacing = 10
        headerView.addSubview(headerStackView)

        let mainStackView = UIStackView(arrangedSubviews: [headerView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        hostView.addSubview(mainStackView)

        let views = ["mainStackView": mainStackView, "headerStackView": headerStackView]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "|[mainStackView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainStackView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "|-10-[headerStackView]-10-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[headerStackView]", options: [], metrics: nil, views: views)
        constraints.append(iconImageView.widthAnchor.constraint(equalToConstant: 100))
        constraints.append(iconImageView.heightAnchor.constraint(equalToConstant: 100))
        NSLayoutConstraint.activate(constraints)
    }

}

