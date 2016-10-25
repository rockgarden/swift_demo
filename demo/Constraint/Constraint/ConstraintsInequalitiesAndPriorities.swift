
import UIKit

class ConstraintsInequalitiesAndPriorities : UIViewController {

    @IBOutlet var lab1 : UILabel!
    @IBOutlet var lab2 : UILabel!
    @IBOutlet var label : UILabel!
    @IBOutlet var button : UIButton!
    @IBAction func doWiden(_ sender:AnyObject?) {
        self.lab1.text = self.lab1.text! + "xxxxx"
        self.lab2.text = self.lab2.text! + "xxxxx"
        self.label.text = self.label.text! + "xxxxx"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.lab1.translatesAutoresizingMaskIntoConstraints = false
        self.lab2.translatesAutoresizingMaskIntoConstraints = false
        let d = dictionaryOfNames(lab1,lab2)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-70-[v1]", options: [], metrics: nil, views: d),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-70-[v2]", options: [], metrics: nil, views: d),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-20-[v1]", options: [], metrics: nil, views: d),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[v2]-20-|", options: [], metrics: nil, views: d),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[v1(>=100)]-(>=20)-[v2(>=100)]", options: [], metrics: nil, views: d)
            ].joined().map{$0})
        // added width shrinkage limit to both labels, so neither gets driven down to invisibility
        // we will be ambiguous when the label texts grow
        // one way to solve: different compression resistance priorities

        let p = self.lab2.contentCompressionResistancePriority(for: .horizontal)
        self.lab1.setContentCompressionResistancePriority(p+1, for: .horizontal)
        
        // print(self.lab1.contentCompressionResistancePriorityForAxis(.Horizontal))
        // print(self.lab2.contentCompressionResistancePriorityForAxis(.Horizontal))
        // print(self.lab1.contentHuggingPriorityForAxis(.Horizontal))
        // print(self.lab2.contentHuggingPriorityForAxis(.Horizontal))

        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false

        let d2 = dictionaryOfNames(button, label)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[v1]-(112)-|", options: [], metrics: nil, views: d2),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(>=10)-[v2]-[v1]-(>=10)-|",
                options: NSLayoutFormatOptions.alignAllLastBaseline,
                metrics: nil, views: d2)
            ].joined().map{$0})

        let con = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        con.priority = 700 // try commenting this out to see the difference in behavior
        NSLayoutConstraint.activate([con])
    }

}
