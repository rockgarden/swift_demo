

import UIKit

/*
 Demonstrating the Designable View feature. 演示可设计的视图功能。
 The view must be marked IBDesignable.
 */

@IBDesignable class IBDesignable_View: UIView {

    @IBInspectable var name : String!

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.configure()
    }

    func configure() {
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let v2 = UIView()
        v2.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0, alpha: 1)
        let v3 = UIView()
        v3.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)

        v2.translatesAutoresizingMaskIntoConstraints = false
        v3.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(v2)
        self.addSubview(v3)

        NSLayoutConstraint.activate([
            v2.leftAnchor.constraint(equalTo: self.leftAnchor),
            v2.rightAnchor.constraint(equalTo: self.rightAnchor),
            v2.topAnchor.constraint(equalTo: self.topAnchor),
            v2.heightAnchor.constraint(equalToConstant: 10),
            v3.widthAnchor.constraint(equalToConstant: 20),
            v3.heightAnchor.constraint(equalTo: v3.widthAnchor),
            v3.rightAnchor.constraint(equalTo: self.rightAnchor),
            v3.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
    }

    /*
     在Interface Builder中创建可设计对象时调用。
     当Interface Builder使用IB_DESIGNABLE属性实例化一个类时，它调用此方法让生成的对象知道它是在设计时创建的。 您可以在可设计的类中实现此方法，并使用它来配置其设计时的外观。
     系统不调用此方法; 只有Interface Builder调用它。
     Interface Builder等待直到在调用此方法之前，图形中的所有对象都已创建和初始化。 因此，如果对象的运行时配置依赖于子视图或父视图，则在调用此方法时应该存在这些对象。
     您的这种方法的实现必须在某个时候调用super，以便父类可以执行自己的自定义设置。
     */
    override func prepareForInterfaceBuilder() {
        self.backgroundColor = UIColor(red: 1, green: 0.4, blue: 1, alpha: 1)
        let lab = UILabel()
        lab.text = self.name
        lab.sizeToFit()
        self.addSubview(lab) //change the inspectable `name` in IB, and the label changes
    }

    override func willMove(toSuperview newSuperview: UIView!) {
        self.configure()
    }
    
}
