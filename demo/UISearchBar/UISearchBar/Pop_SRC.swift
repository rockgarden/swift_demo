
import UIKit

class Pop_SRC: UITableViewController {
	var originalData: [String]
	var filteredData = [String]()

	init(data: [[String]]) {

		var flattened = [String]()
		for arr in data {
			for s in arr {
				flattened += [s]
			}
		}
		self.originalData = data.flatMap{$0}
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder: NSCoder) {
		fatalError("NSCoding not supported")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.filteredData.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel!.text = self.filteredData[indexPath.row]
		return cell
	}
}


extension Pop_SRC: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		print("update")
		let sb = searchController.searchBar
		let target = sb.text!
		self.filteredData = self.originalData.filter {
			s in
			let options = NSString.CompareOptions.caseInsensitive
			let found = (s as NSString).range(of: target, options: options).length
			return (found != 0)
		}
		self.tableView.reloadData()
	}
}
