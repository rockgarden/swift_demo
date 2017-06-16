

import UIKit

class Pep: UIViewController {

    let boy : String
    @IBOutlet var name : UILabel!
    @IBOutlet var pic : UIImageView!

    /*
     available(iOS 9.0, *) for 3D Touch
     此属性用于在执行previewingContext（_：viewControllerForLocation :)委托方法时提供的预览视图控制器。
     实施此方法可为此类预览提供快速操作。 当用户在预览中向上滑动时，系统会将这些快速操作项目显示在预览下方的工作表中。
     此方法的默认实现返回一个空数组。
     UIPreviewActionItem协议由UIPreviewAction和UIPreviewActionGroup类采用。
     重要
     不要在自定义类中使用此协议。
     此协议定义了您可以应用于浏览快速操作和窥视快速操作组的样式，并定义了一个只读访问器，以便用户可以看到快速行动的标题。
     */
    override var previewActionItems: [UIPreviewActionItem] {
        // example of submenu (group)
        let col1 = UIPreviewAction(title:"Blue", style: .default) {
            action, vc in print ("coloring this pep boy", action.title.lowercased())
        }
        let col2 = UIPreviewAction(title:"Green", style: .default) {
            action, vc in print ("coloring this pep boy", action.title.lowercased())
        }
        let col3 = UIPreviewAction(title:"Red", style: .default) {
            action, vc in print ("coloring this pep boy", action.title.lowercased())
        }
        let group = UIPreviewActionGroup(title: "Colorize", style: .default, actions: [col1, col2, col3])
        // example of selected style
        let favKey = "favoritePepBoy"
        let style : UIPreviewActionStyle =
            self.boy == UserDefaults.standard.string(forKey:favKey) ? .selected : .default
        let fav = UIPreviewAction(title: "Favorite", style: style) {
            action, vc in
            if let pep = vc as? Pep {
                // make this pep boy favorite
                print("\(pep.boy) is now your favorite")
                UserDefaults.standard.set(pep.boy, forKey:favKey)
            }
        }
        return [group, fav]
    }

    init(pepBoy boy:String) {
        self.boy = boy
        super.init(nibName: "Pep", bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = self.boy
        self.pic.image = UIImage(named:"\(self.boy.lowercased())")
    }

    override var description : String {
        return self.boy
    }

}
