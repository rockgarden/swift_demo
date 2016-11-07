//
//  ViewController.swift
//  TableView
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class UISearchControllerVC: UIViewController, UITableViewDelegate {
    
    var myTableView = UITableView()
    var searcher: UISearchController!
    // data + section array
    var dataSource = NSArray()
    var sectionTitlesArray = NSMutableArray()
    // 资源文件数据
    var dictData: NSDictionary!
    var listGroupName: NSArray!
    // TXT数据
    var sectionNames = [String]()
    var sectionData = [[String]]()
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDataForTableView()
        self.txtDataForTableView()
        self.addSubView()
        self.setupSearchVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        myTableView.reloadData()
        myTableView.scrollToRow(
            at: IndexPath(row: 0, section: 0),
            at: .top, animated: false)
    }
    
    func addSubView() {
        myTableView = UITableView(frame: self.view.bounds)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.sectionIndexBackgroundColor = UIColor.clear
        myTableView.sectionIndexColor = UIColor.lightGray
        // myTableView.sectionIndexTrackingBackgroundColor = UIColor.blueColor()
        myTableView.backgroundColor = UIColor.gray // but the search bar covers that
        myTableView.backgroundView = { // this will fix it
            let v = UIView()
            v.backgroundColor = UIColor.gray
            return v
        }()
        myTableView.rowHeight = 68
        myTableView.sectionHeaderHeight = 28
        myTableView.sectionFooterHeight = 28
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        self.view.addSubview(myTableView)
    }
    
    func setupSearchVC() {
        // most rudimentary possible search interface
        // instantiate a view controller that will present the search results
        let src = SearchResultsController(data: self.sectionData)
        let searcher = MySearchController(searchResultsController: src)
        self.searcher = searcher
        // specify who the search controller should notify when the search bar changes
        searcher.searchResultsUpdater = src
        // put the search controller's search bar into the interface
        let sb = searcher.searchBar
        sb.sizeToFit() // crucial, trust me on this one
        // b.scopeButtonTitles = ["Hey", "Ho"] // shows during search only; uncomment to see
        // (not used in this example; just showing the interface)
        // WARNING: do NOT call showsScopeBar! it messes things up!
        // (buttons will show during search if there are titles)
        sb.autocapitalizationType = .none

        // put search bar into table Header View
        myTableView.tableHeaderView = sb // 有自动隐藏效果, 只能加载一次

        // put search bar into navigation bar
        self.navigationItem.titleView = sb // *
        searcher.hidesNavigationBarDuringPresentation = false // *
        self.definesPresentationContext = true // *
    }
    
    func setDataForTableView() {
        let testArr = ["786", "朱慧平", "孙悟空", "白骨精", "孙红雷", "唐三藏", "杨阳洋", "TF—Boys", "猪猪", "哈利路亚", "杨幂", "黄轩", "皇上", "太上皇"]
        let personArr = NSMutableArray()
        for str in testArr {
            let p = Person.init(name: str)
            personArr.add(p)
        }
        let collation = UILocalizedIndexedCollation.current()
        // 1.获取section的标题
        let titles: NSArray = collation.sectionIndexTitles as NSArray // sectionTitles
        // 2.构建每个section数组
        let sectionArray = NSMutableArray()
        let total = titles.count
        for _ in 1...total {
            let subArr = NSMutableArray()
            sectionArray.add(subArr)
        }
        // 3.排序
        // 3.1按照将需要排序的对象放入到对应分区数组
        for p in personArr {
            let section: NSInteger = collation
                .section(for: p, collationStringSelector: #selector(getter: UIDevice.name))
            let subArr: NSMutableArray = sectionArray[section] as! NSMutableArray
            subArr.add(p)
        }
        // 3.2分别对分区进行排序
        for subArr in sectionArray {
            let sortArr: NSArray = collation.sortedArray(from: subArr as! [AnyObject], collationStringSelector: #selector(getter: UIDevice.name)) as NSArray
            (subArr as AnyObject).removeAllObjects()
            (subArr as AnyObject).addObjects(from: sortArr as [AnyObject])
        }
        // 4.删除分区为空的内容
        let temp = NSMutableArray()
        sectionArray.enumerateObjects({ (arr, idx, stop) in
            let array = arr as! NSArray
            if (array.count > 0) {
                let titleArr = collation.sectionIndexTitles as NSArray
                self.sectionTitlesArray.add(titleArr.object(at: idx))
            } else {
                temp.add(arr)
            }
        })
        sectionArray.removeObjects(in: temp as [AnyObject])
        self.dataSource = sectionArray.copy() as! NSArray
    }
    
    func plistDataForTableView() {
        let plistPath = Bundle.main.path(forResource: "team_dictionary", ofType: "plist")
        // 获取属性列表文件中的全部数据
        self.dictData = NSDictionary(contentsOfFile: plistPath!)
        let tempList = self.dictData.allKeys as NSArray
        // 对keys进行排序，字典本身乱序
        print(tempList)
        self.listGroupName = tempList.sortedArray(using: #selector(NSString.compare(_:))) as NSArray
        print(listGroupName)
    }
    
    func txtDataForTableView() {
        let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!, encoding: String.Encoding.utf8)
        let states = s.components(separatedBy: "\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append(c.uppercased())
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append([String]())
            }
            sectionData[sectionData.count - 1].append(aState)
        }
    }
    
}

extension UISearchControllerVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // return self.listGroupName.count
        
        // return self.sectionNames.count
        
        return self.dataSource.count
    }
    
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // //按照节索引从小组名中获得组名
        // let groupName = self.listGroupName[section] as! String
        // //将组名作为Key，从字典中取出球队数组集合
        // let groupTeams = self.dictData[groupName] as! NSArray
        // return groupTeams.count
        
        // return self.sectionData[section].count
        
        return (self.dataSource.object(at: section) as AnyObject).count
    }
    
    // Section Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // return self.listGroupName[section] as? String
        
        // return self.sectionNames[section]
        
        return self.sectionTitlesArray.object(at: section) as? String
    }
    
    // 为表视图提供索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // let tempIndex = NSMutableArray(capacity: self.listGroupName.count)
        // for item in self.listGroupName{
        // let title = item.substringToIndex(1) as String
        // tempIndex.addObject(title)
        // }
        // let reslutIndex = NSArray(array: tempIndex)
        // return reslutIndex as? [String]
        
        // return self.sectionNames
        
        return self.sectionTitlesArray.copy() as? [String]
    }
    
    // this is more "interesting"
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let h = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header")!
//        if h.tintColor != UIColor.redColor() {
//            h.tintColor = UIColor.redColor() // invisible marker, tee-hee
//            h.backgroundView = UIView()
//            h.backgroundView?.backgroundColor = UIColor.blackColor()
//            let lab = UILabel()
//            lab.tag = 1
//            lab.font = UIFont(name:"Georgia-Bold", size:22)
//            lab.textColor = UIColor.greenColor()
//            lab.backgroundColor = UIColor.clearColor()
//            h.contentView.addSubview(lab)
//            let v = UIImageView()
//            v.tag = 2
//            v.backgroundColor = UIColor.blackColor()
//            v.image = UIImage(named:"us_flag_small.gif")
//            h.contentView.addSubview(v)
//            lab.translatesAutoresizingMaskIntoConstraints = false
//            v.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activateConstraints([
//                NSLayoutConstraint.constraintsWithVisualFormat(
//                    "H:|-5-[lab(25)]-10-[v(40)]",
//                    options:[], metrics:nil, views:["v":v, "lab":lab]),
//                NSLayoutConstraint.constraintsWithVisualFormat(
//                    "V:|[v]|",
//                    options:[], metrics:nil, views:["v":v]),
//                NSLayoutConstraint.constraintsWithVisualFormat(
//                    "V:|[lab]|",
//                    options:[], metrics:nil, views:["lab":lab])
//                ].flatten().map{$0})
//        }
//        let lab = h.contentView.viewWithTag(1) as! UILabel
//        lab.text = self.sectionNames[section]
//        return h
//    }

    // MARK:－cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellIdentifier"
        // 纯代码重用单元格
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier) // .Default .Subtitle .Value1 .Value2 单元格四种样式 reuseIdentifier = nil 不reuse
        }
        // 视图中指定重用单元格
        // let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        // //获得选择的节
        // let section = indexPath.section
        // //获得选择节中选中的行索引
        // let row = indexPath.row
        // //按照节索引从小组名中获得组名
        // let groupName = self.listGroupName[section] as! String
        // //将组名作为key,从字典中取出球队数组集合
        // let groupTeam = self.dictData[groupName] as! NSArray
        // //获取球队名作为列表项名
        // cell.textLabel?.text = groupTeam[row] as? String
        
        //        let s = self.sectionData[indexPath.section][indexPath.row]
        //        cell.textLabel!.text = s
        //        // this part is not in the book, it's just for fun
        //        var stateName = s
        //        stateName = stateName.lowercaseString
        //        stateName = stateName.stringByReplacingOccurrencesOfString(" ", withString:"")
        //        stateName = "flag_\(stateName).gif"
        //        let im = UIImage(named: stateName)
        //        cell.imageView!.image = im
        
        cell.textLabel?.text = ((self.dataSource.object(at: indexPath.section) as! NSArray).object(at: indexPath.row) as AnyObject).name
        cell.detailTextLabel?.text = "Cell Subtitle"
        cell.imageView!.image = UIImage(named: "image1.png")
    }

    // Foot Subtitle
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil // "No More"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        debugPrint(view) // prove we are reusing header views
    }
}

class MySearchController: UISearchController {
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

