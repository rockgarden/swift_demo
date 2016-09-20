//
//  Springboard.swift
//  UIStackView
//
//  Created by wangkan on 16/9/20.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class Springboard: UIViewController {
    
    let hostView = UIView(frame: CGRect(x: 0, y: 64, width: 320, height: 500))
    let makeView = { (color: UIColor) -> UIView in
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }
    
    convenience init(frame: CGRect) {
        self.init(nibName: nil, bundle: nil)
        title = "Springboard"
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(hostView)
    }
    
    func setup() {
        hostView.backgroundColor = .blackColor()
        
        let timeLabel = UILabel()
        timeLabel.text = "9:41 AM"
        timeLabel.textColor = .whiteColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(13)
        timeLabel.textAlignment = .Center
        
        let calendarImageView = UIImageView(image: UIImage(named: "calendar"))
        let photosImageView = UIImageView(image: UIImage(named: "photos"))
        let mapsImageView = UIImageView(image: UIImage(named: "maps"))
        let remindersImageView = UIImageView(image: UIImage(named: "notes"))
        let healthImageView = UIImageView(image: UIImage(named: "health"))
        let settingsImageView = UIImageView(image: UIImage(named: "settings"))
        let safariImageView = UIImageView(image: UIImage(named: "safari"))
        
        let labelWithText = { (text: String) -> UILabel in
            let label = UILabel()
            label.text = text
            label.textColor = .whiteColor()
            label.font = UIFont.systemFontOfSize(12)
            label.textAlignment = .Center
            return label
        }
        
        let calendarLabel = labelWithText("Calendar")
        let photosLabel = labelWithText("Photos")
        let mapsLabel = labelWithText("Maps")
        let remindersLabel = labelWithText("Reminders")
        let healthLabel = labelWithText("Health")
        let settingsLabel = labelWithText("Settings")
        let safariLabel = labelWithText("Safari")
        
        
        let appStackViewWithArrangedViews = { (views: [UIView]) -> UIStackView in
            let stackView = UIStackView(arrangedSubviews: views)
            stackView.axis = .Vertical
            stackView.distribution = .EqualSpacing
            stackView.spacing = 3
            return stackView
        }
        
        let calendarStackView = appStackViewWithArrangedViews([calendarImageView, calendarLabel])
        let photosStackView = appStackViewWithArrangedViews([photosImageView, photosLabel])
        let mapsStackView = appStackViewWithArrangedViews([mapsImageView, mapsLabel])
        let remindersStackView = appStackViewWithArrangedViews([remindersImageView, remindersLabel])
        let healthStackView = appStackViewWithArrangedViews([healthImageView, healthLabel])
        let settingsStackView = appStackViewWithArrangedViews([settingsImageView, settingsLabel])
        let safariStackView = appStackViewWithArrangedViews([safariImageView, safariLabel])
        
        let firstColumnStackView = appStackViewWithArrangedViews([calendarStackView, healthStackView])
        firstColumnStackView.spacing = 10
        let secondColumnStackView = appStackViewWithArrangedViews([photosStackView, settingsStackView])
        secondColumnStackView.spacing = 10
        
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        
        let safariColumnStackView = appStackViewWithArrangedViews([pageControl, safariStackView])
        
        let firstRowStackView = UIStackView(arrangedSubviews: [firstColumnStackView, secondColumnStackView, mapsStackView, remindersStackView])
        firstRowStackView.distribution = .EqualSpacing
        firstRowStackView.alignment = .Top
        firstRowStackView.spacing = 15
        
        let topStackView = UIStackView(arrangedSubviews: [timeLabel, firstRowStackView])
        topStackView.axis = .Vertical
        topStackView.spacing = 5
        
        //let bottomStackView = UIStackView(arrangedSubviews: [safariStackView])
        //bottomStackView.alignment = .Top
        //bottomStackView.distribution = .EqualSpacing
        
        let dockBackgroundView = UIView()
        dockBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        dockBackgroundView.backgroundColor = UIColor(white: 0.35, alpha: 1.0)
        
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = .grayColor()
        infoLabel.text = "Build with UIStackViews"
        
        let mainStackView = UIStackView(arrangedSubviews: [topStackView, safariColumnStackView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .Vertical
        mainStackView.distribution = .EqualSpacing
        mainStackView.alignment = .Center
        
        hostView.addSubview(dockBackgroundView)
        hostView.addSubview(mainStackView)
        hostView.addSubview(infoLabel)
        
        let views = ["stackView": mainStackView, "dockBackground": dockBackgroundView]
        var layoutConstraints = [NSLayoutConstraint]()
        layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|[stackView]|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-3-[stackView]-3-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|[dockBackground]|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:[dockBackground(95)]|", options: [], metrics: nil, views: views)
        layoutConstraints.append(infoLabel.centerXAnchor.constraintEqualToAnchor(hostView.centerXAnchor))
        layoutConstraints.append(infoLabel.centerYAnchor.constraintEqualToAnchor(hostView.centerYAnchor))
        
        layoutConstraints.append(calendarImageView.widthAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(calendarImageView.heightAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(photosImageView.widthAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(photosImageView.heightAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(mapsImageView.widthAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(mapsImageView.heightAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(remindersImageView.widthAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(remindersImageView.heightAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(healthImageView.widthAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(healthImageView.heightAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(settingsImageView.widthAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(settingsImageView.heightAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(safariImageView.widthAnchor.constraintEqualToConstant(60))
        layoutConstraints.append(safariImageView.heightAnchor.constraintEqualToConstant(60))
        
        NSLayoutConstraint.activateConstraints(layoutConstraints)
        
    }
    
    func makeButtonWithTitle(title: String, selector: String, tag: Int) -> UIButton {
        let button = UIButton(type: .System)
        button.tintColor = UIColor.blackColor()
        switch tag {
        case 0...10:
            button.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        case 101...110:
            button.backgroundColor = UIColor.orangeColor()
            button.tintColor = .whiteColor()
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 50)
        default:
            button.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
        }
        button.setTitle(title, forState: .Normal)
        button.tag = tag
        return button
    }
    
}
