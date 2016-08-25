//
//  ViewController.swift
//  TableView
//
//  Created by wangkan on 16/8/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
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
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDataForTableView()
        self.txtDataForTableView()
        self.addSubView()
        self.setupSearchVC()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        myTableView.reloadData()
        myTableView.scrollToRowAtIndexPath(
            NSIndexPath(forRow: 0, inSection: 0),
            atScrollPosition: .Top, animated: false)
    }
    
    func addSubView() {
        myTableView = UITableView(frame: self.view.bounds)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.sectionIndexBackgroundColor = UIColor.clearColor()
        myTableView.sectionIndexColor = UIColor.lightGrayColor()
        // myTableView.sectionIndexTrackingBackgroundColor = UIColor.blueColor()
        myTableView.backgroundColor = UIColor.grayColor() // but the search bar covers that
        myTableView.backgroundView = { // this will fix it
            let v = UIView()
            v.backgroundColor = UIColor.grayColor()
            return v
        }()
        myTableView.rowHeight = 68
        myTableView.sectionHeaderHeight = 28
        myTableView.sectionFooterHeight = 28
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
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
        sb.autocapitalizationType = .None

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
            personArr.addObject(p)
        }
        let collation = UILocalizedIndexedCollation.currentCollation()
        // 1.获取section的标题
        let titles: NSArray = collation.sectionIndexTitles // sectionTitles
        // 2.构建每个section数组
        let sectionArray = NSMutableArray()
        let total = titles.count
        for _ in 1...total {
            let subArr = NSMutableArray()
            sectionArray.addObject(subArr)
        }
        // 3.排序
        // 3.1按照将需要排序的对象放入到对应分区数组
        for p in personArr {
            let section: NSInteger = collation
                .sectionForObject(p, collationStringSelector: Selector("name"))
            let subArr: NSMutableArray = sectionArray[section] as! NSMutableArray
            subArr.addObject(p)
        }
        // 3.2分别对分区进行排序
        for subArr in sectionArray {
            let sortArr: NSArray = collation.sortedArrayFromArray(subArr as! [AnyObject], collationStringSelector: Selector("name"))
            subArr.removeAllObjects()
            subArr.addObjectsFromArray(sortArr as [AnyObject])
        }
        // 4.删除分区为空的内容
        let temp = NSMutableArray()
        sectionArray.enumerateObjectsUsingBlock { (arr: AnyObject, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            let array: NSArray = arr as! NSArray
            if Bool(array.count) {
                let titleArr: NSArray = collation.sectionIndexTitles
                self.sectionTitlesArray.addObject(titleArr.objectAtIndex(idx))
            } else {
                temp.addObject(arr)
            }
        }
        sectionArray.removeObjectsInArray(temp as [AnyObject])
        self.dataSource = sectionArray.copy() as! NSArray
    }
    
    func plistDataForTableView() {
        let plistPath = NSBundle.mainBundle().pathForResource("team_dictionary", ofType: "plist")
        // 获取属性列表文件中的全部数据
        self.dictData = NSDictionary(contentsOfFile: plistPath!)
        let tempList = self.dictData.allKeys as NSArray
        // 对keys进行排序，字典本身乱序
        print(tempList)
        self.listGroupName = tempList.sortedArrayUsingSelector(#selector(NSString.compare(_:)))
        print(listGroupName)
    }
    
    func txtDataForTableView() {
        let s = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("states", ofType: "txt")!, encoding: NSUTF8StringEncoding)
        let states = s.componentsSeparatedByString("\n")
        var previous = ""
        for aState in states {
            // get the first letter
            let c = String(aState.characters.prefix(1))
            // only add a letter to sectionNames when it's a different letter
            if c != previous {
                previous = c
                self.sectionNames.append(c.uppercaseString)
                // and in that case also add new subarray to our array of subarrays
                self.sectionData.append([String]())
            }
            sectionData[sectionData.count - 1].append(aState)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return self.listGroupName.count
        
        // return self.sectionNames.count
        
        return self.dataSource.count
    }
    
    // Number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // //按照节索引从小组名中获得组名
        // let groupName = self.listGroupName[section] as! String
        // //将组名作为Key，从字典中取出球队数组集合
        // let groupTeams = self.dictData[groupName] as! NSArray
        // return groupTeams.count
        
        // return self.sectionData[section].count
        
        return self.dataSource.objectAtIndex(section).count
    }
    
    // Section Title
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // return self.listGroupName[section] as? String
        
        // return self.sectionNames[section]
        
        return self.sectionTitlesArray.objectAtIndex(section) as? String
    }
    
    // 为表视图提供索引
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CellIdentifier"
        // 纯代码重用单元格
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier) // .Default .Subtitle .Value1 .Value2 单元格四种样式 reuseIdentifier = nil 不reuse
        }
        // 视图中指定重用单元格
        // let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
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
        
        cell.textLabel?.text = self.dataSource.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row).name
        cell.detailTextLabel?.text = "Cell Subtitle"
        cell.imageView!.image = UIImage(named: "image1.png")
    }
    
    // Foot Subtitle
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil // "No More"
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        debugPrint(view) // prove we are reusing header views
    }
}

class MySearchController: UISearchController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

