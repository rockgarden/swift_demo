
import UIKit

class LayoutMargins: UIViewController {

    var didSetup = false

    override func viewDidLayoutSubviews() {
        if self.didSetup {return}
        self.didSetup = true

        let mainview = self.view

        let v = UIView()
        v.backgroundColor = UIColor.red
        v.translatesAutoresizingMaskIntoConstraints = false

        mainview?.addSubview(v)

        NSLayoutConstraint.activate([
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[v]-(0)-|", options: [], metrics: nil, views: ["v":v]),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[v]-(0)-|", options: [], metrics: nil, views: ["v":v])
            ].joined().map{$0})

        // experiment by commenting out this line
        /// default is NO - set to enable pass-through or cascading behavior of margins from this view’s parent to its children
        v.preservesSuperviewLayoutMargins = true

        let v1 = UIView()
        v1.backgroundColor = UIColor.green
        v1.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(v1)

        var which : Int {return 3}
        switch which {

        case 1:
            // no longer need delayed performance here
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v1]-|", options: [], metrics: nil, views: ["v1":v1]),
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v1]-|", options: [], metrics: nil, views: ["v1":v1])
                ].joined().map{$0})

        case 2:
            // new notation treats margins as a pseudoview (UILayoutGuide)
            NSLayoutConstraint.activate([
                v1.topAnchor.constraint(equalTo: v.layoutMarginsGuide.topAnchor),
                v1.bottomAnchor.constraint(equalTo: v.layoutMarginsGuide.bottomAnchor),
                v1.trailingAnchor.constraint(equalTo: v.layoutMarginsGuide.trailingAnchor),
                v1.leadingAnchor.constraint(equalTo: v.layoutMarginsGuide.leadingAnchor)
                ])

        case 3:
            // new kind of margin, "readable content"
            // particularly dramatic on iPad in landscape
            NSLayoutConstraint.activate([
                v1.topAnchor.constraint(equalTo: v.readableContentGuide.topAnchor),
                v1.bottomAnchor.constraint(equalTo: v.readableContentGuide.bottomAnchor),
                v1.trailingAnchor.constraint(equalTo: v.readableContentGuide.trailingAnchor),
                v1.leadingAnchor.constraint(equalTo: v.readableContentGuide.leadingAnchor)
                ])

        default:break
        }

    }
    
}

