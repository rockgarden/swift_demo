import UIKit

class Pop_SRC_VC: UITableViewController, UISearchBarDelegate {
	var sectionNames = [String]()
	var sectionData = [[String]]()
	var searcher: UISearchController!

	override func viewDidLoad() {
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
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
		self.tableView.sectionIndexColor = UIColor.white
		self.tableView.sectionIndexBackgroundColor = UIColor.red
		self.tableView.sectionIndexTrackingBackgroundColor = UIColor.blue
		self.tableView.backgroundColor = UIColor.yellow

        setupPop_SRC()
    }

    //FIXME: Just run on iPad
    fileprivate func setupPop_SRC() {
		// this is the only important part of this class! create popover searcher
		// instantiate a view controller that will present the search results
		let src = Pop_SRC(data: self.sectionData)
		// instantiate a search controller and keep it alive
		let searcher = UISearchController(searchResultsController: src)
		self.searcher = searcher
		// no effect in this situation:
		searcher.hidesNavigationBarDuringPresentation = false
		// searcher.dimsBackgroundDuringPresentation = false
		// FIXME: make it a popover! 设置definesPresentationContext为true，我们保证在UISearchController在激活状态下用户push到下一个view controller之后search bar仍留在界面上。
		self.definesPresentationContext = true
		searcher.modalPresentationStyle = .popover
		searcher.preferredContentSize = CGSize(width: 400, height: 400)
		// specify who the search controller should notify when the search bar changes
		// searchResultUpdater是UISearchController的一个属性，它的值必须实现UISearchResultsUpdating协议，这个协议让我们的类在UISearchBar文字改变时被通知到
		searcher.searchResultsUpdater = src
		// put the search controller's search bar into the interface
		let b = searcher.searchBar
		// b.sizeToFit()
		// b.frame.size.width = 250
		b.autocapitalizationType = .none
		self.navigationItem.titleView = b
		b.showsCancelButton = true // no effect

		// could proceed to configure the UISearchController further...
		// or could configure its presentationController (a UIPopoverPresentationController)
		// but there is no need; the defaults are fine

		// however, I'm having difficulty detecting dismissal of the popover
		searcher.delegate = self
		if let pres = searcher.presentationController {
			print("setting presentation controller delegate")
			pres.delegate = self
		}
		//(searcher.presentationController as! UIPopoverPresentationController).delegate = self
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return self.sectionNames.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.sectionData[section].count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let s = self.sectionData[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
		cell.textLabel!.text = s
		// this part is not in the book, it's just for fun
		var stateName = s
		stateName = stateName.lowercased()
		stateName = stateName.replacingOccurrences(of: " ", with: "")
		stateName = "flag_\(stateName).gif"
		let im = UIImage(named: stateName)
		cell.imageView!.image = im
		return cell
	}

	/*
	 override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
	 return self.sectionNames[section]
	 }
	 */
	// this is more "interesting"
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let h = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")!
		if h.tintColor != UIColor.red {
			// print("configuring a new header view") // only called about 7 times
			h.tintColor = UIColor.red // invisible marker, tee-hee
			h.backgroundView = UIView()
			h.backgroundView!.backgroundColor = UIColor.black
			let lab = UILabel()
			lab.tag = 1
			lab.font = UIFont(name: "Georgia-Bold", size: 22)
			lab.textColor = UIColor.green
			lab.backgroundColor = UIColor.clear
			h.contentView.addSubview(lab)
			let v = UIImageView()
			v.tag = 2
			v.backgroundColor = UIColor.black
			v.image = UIImage(named: "us_flag_small.gif")
			h.contentView.addSubview(v)
			lab.translatesAutoresizingMaskIntoConstraints = false
			v.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lab(25)]-10-[v(40)]",
					options: [], metrics: nil, views: ["v": v, "lab": lab]),
				NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|",
					options: [], metrics: nil, views: ["v": v]),
				NSLayoutConstraint.constraints(withVisualFormat: "V:|[lab]|",
					options: [], metrics: nil, views: ["lab": lab])
				].joined().map { $0 })
		}
		let lab = h.contentView.viewWithTag(1) as! UILabel
		lab.text = self.sectionNames[section]
		return h
	}

	/*
	 override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
	 print(view) // prove we are reusing header views
	 }
	 */

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return self.sectionNames
	}

}

extension Pop_SRC_VC: UISearchControllerDelegate {
	func presentSearchController(_ searchController: UISearchController) { print(#function) }
	func willPresentSearchController(_ searchController: UISearchController) { print(#function) }
	func didPresentSearchController(_ searchController: UISearchController) { print(#function) }
	// these next functions are not called, I regard this as a bug
	func willDismissSearchController(_ searchController: UISearchController) { print(#function) }
	func didDismissSearchController(_ searchController: UISearchController) { print(#function) }
}

extension Pop_SRC_VC: UIPopoverPresentationControllerDelegate {
	func prepareForPopoverPresentation(_ pop: UIPopoverPresentationController) {
		print("prepare")
		// print(pop.sourceView)
		// print(pop.passthroughViews)
		// print(pop.delegate)
	}

	func popoverPresentationControllerShouldDismissPopover(_ pop: UIPopoverPresentationController) -> Bool {
		print("pop should dismiss")
		self.searcher.searchBar.text = nil // woo-hoo! fix dismissal failure to empty
		return true
	}
    
	func popoverPresentationControllerDidDismissPopover(_ pop: UIPopoverPresentationController) {
		print("pop dismiss")
		self.searcher.presentationController?.delegate = self // this is the big bug fix
	}
}

// not called, seems like a bug to me
extension Pop_SRC_VC: UIAdaptivePresentationControllerDelegate {
	func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
		return .none
	}
}
