
import UIKit

class IndividualCellsVC: UITableViewController {
    
    var cells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        self.tableView.rowHeight = 58 // *
        if #available(iOS 10.0, *) {
            self.tableView.prefetchDataSource = self
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000 /// make a lot of rows this time!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("will", indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("did end", indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell", indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath) as! MyCell

        let lab = cell.theLabel!
        // TODO: 证明许多行并不意味着很多单元格对象. prove that many rows does not mean many cell objects
        lab.text = "Row \(indexPath.row) of section \(indexPath.section)"
        //／ 证明 lab 开始复用
        if lab.tag != 999 {
            lab.tag = 999
            self.cells += 1
            print("New cell \(self.cells), tag \(lab.tag)")
        }

        let iv = cell.theImageView!
        
        // shrink apparent size of image
        let im = UIImage(named:"image1")!
        let im2: UIImage!
        if #available(iOS 10.0, *) {
            let r = UIGraphicsImageRenderer(size: CGSize(36,36))
            im2 = r.image {
                _ in im.draw(in:CGRect(0,0,36,36))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(36,36), true, 0.0)
            im.draw(in:CGRect(0,0,36,36))
            im2 = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        iv.image = im2
        iv.contentMode = .center
        
        return cell
    }

}


extension IndividualCellsVC : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetch", indexPaths)
    }
}


/// cell subclass 仅存在于我们可以通过名称而不是标签号来接收子视图
class MyCell : UITableViewCell {
    @IBOutlet var theLabel : UILabel!
    @IBOutlet var theImageView : UIImageView!
}

