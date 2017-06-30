//
//  SizeClasses.swift
//  Constraint
//
//  Created by wangkan on 2016/11/6.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class SizeClasses: UIViewController {

    @IBOutlet var lab : UILabel!

    @IBOutlet weak var con1: NSLayoutConstraint!
    @IBOutlet weak var con2: NSLayoutConstraint!

    /*
     约束定义了基于约束的布局系统必须满足的两个用户界面对象之间的关系。每个约束是具有以下格式的线性方程：
     
     item1.attribute1 = multiplier×item2.attribute2 +常量
     在这个方程中，attribute1和attribute2是自动布局在解决这些约束时可以调整的变量。创建约束时定义其他值。例如，如果要定义两个按钮的相对位置，则可以说“第一个按钮的后沿之后第二个按钮的前沿应该是8个点。”这个关系的线性方程如下所示：

     //正值从左到右的语言（如英语）向右移动。
     button2.leading = 1.0×button1.trailing + 8.0
     自动布局然后修改指定的前沿和后沿的值，直到方程的两边相等。请注意，自动布局不会简单地将该方程右侧的值分配给左侧。相反，系统可以根据需要修改属性或两个属性来解决此约束。
     约束是方程（而不是分配运算符）的事实意味着您可以根据需要切换方程中的项目的顺序，以更清楚地表达所需的关系。但是，如果您切换顺序，还必须反转乘数和常数。例如，以下两个方程产生相同的约束：

     //这些方程产生相同的约束
     button2.leading = 1.0×button1.trailing + 8.0
     button1.trailing = 1.0×button2.leading - 8.0
     一个有效的布局被定义为具有唯一一个可能的解决方案的集约束。有效的布局也被称为非明确的，非冲突的布局。多个解决方案的约束是不明确的。没有有效解决方案的约束是冲突的。有关解决歧义和冲突约束的更多信息，请参阅“自动布局指南”中的“错误类型”。
     另外，约束不限于平等关系。它们也可以使用大于或等于（> =）或小于或等于（<=）来描述两个属性之间的关系。约束也有优先级在1到1,000之间。优先级为1,000的限制是必需的。小于1,000的所有优先级是可选的。默认情况下，所有约束都是必需的（priority = 1,000）。
     解决所需的约束后，自动布局会尝试以最高到最低的优先级顺序解决所有可选约束。如果它不能解决一个可选约束，它会尝试尽可能接近所需的结果，然后移动到下一个约束。
     不平等，平等和优先事项的结合给了你很大的灵活性和权力。通过组合多个约束，您可以定义随着用户界面中元素的大小和位置的变化而动态调整的布局。
     */
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("trait collection did change")
        /// traitCollection 视图控制器（UIViewController类的一个实例或其子类的一个实例）或视图（UIView类的实例或其子类之一）的trait集合。视图控制器和视图采用UITraitEnvironment协议。
        /// 重要-直接使用traitCollection属性。 不要覆盖它。 不提供自定义实现。
        let tc = self.traitCollection
        print(tc)
        if tc.horizontalSizeClass == .regular {
            print("regular")
            if self.con1 != nil {
                print("changing constraints")
                NSLayoutConstraint.deactivate([self.con1, self.con2])
                NSLayoutConstraint.activate([
                    NSLayoutConstraint.constraints(withVisualFormat: "V:[tg]-[lab]", options: [], metrics: nil, views: ["tg":self.topLayoutGuide, "lab":self.lab]),
                    [self.lab.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)]
                    ].joined().map{$0})
                let sz = self.lab.font.pointSize * 2
                self.lab.font = self.lab.font.withSize(sz)
            }
        }
    }

}


