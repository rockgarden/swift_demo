//
//  ParallaxHeaderVC.swift
//

import UIKit

class ParallaxHeaderVC: UITableViewController, ParallaxHeaderViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setMyBackgroundColor(UIColor(red: 0/255.0, green: 130/255.0, blue: 210/255.0, alpha: 0))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 100))
        imageView.image = UIImage(named: "demo-header")
        imageView.contentMode = .scaleAspectFill
        
        let heardView = ParallaxHeaderView(style: .default, subView: imageView, headerViewSize: CGSize(width: self.tableView.bounds.width, height: 100), maxOffsetY: -120, delegate: self)

        self.tableView.tableHeaderView = heardView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "test\(indexPath.row)"
        return cell!
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let heardView = self.tableView.tableHeaderView as! ParallaxHeaderView
        heardView.layoutHeaderViewWhenScroll(scrollView.contentOffset)
        
    }
}

