//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Andrew Clissold
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//      The above copyright notice and this permission notice shall be included in all
//      copies or substantial portions of the Software.
//
//      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//      SOFTWARE.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 2

    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.CGPath
    }

}


//How to use: yourCard = CardView(width: 200)
//
//add uiview to card:
//
//let headerField = UILabel()
//headerField.text = "To access site features"
//headerField.textAlignment = .center
//headerField.sizeToFit() // make sure you call this to calculate uilabel height.
//yourCard.addArrangedSubview(headerField)
class StackCardView: UIView {
    var totalHeight: CGFloat = 0
    var totalWidth: CGFloat = 0
    var stackView: UIStackView
    
    init(width: CGFloat){
        totalWidth = width
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment     = UIStackViewAlignment.center
        stackView.spacing       = 8
        stackView.layer.shadowOpacity = 0.0;
        
        super.init(frame: CGRect(x: 0, y:  0, width: width, height: 0))
        super.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
        }
        
    }
    
    public func getStackView() -> UIStackView {
        return stackView
    }
    
    public func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
        totalHeight += view.frame.size.height
        totalHeight += 8
    }
    
    public func removeAll() {
        for view in subviews {
            view.removeFromSuperview()
        }
        totalHeight = 0
    }
    
    public func prepareBlankView(height: CGFloat){
        let blankView = UIView(frame: CGRect(x: 0, y:  0, width: totalWidth - 40, height: height))
        blankView.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.addArrangedSubview(blankView)
    }
    
    public func showCardShadow(){
        self.backgroundColor = UIColor.white
        //self.frame = CGRect(x: 0, y: 0, width: totalWidth, height: totalHeight - 8)
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0);
        self.layer.cornerRadius = 0;
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5;
        //self.layer.shouldRasterize = true
        self.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    
    
    override func layoutSubviews() {
        showCardShadow()
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
