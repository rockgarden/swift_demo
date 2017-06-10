
import UIKit

class CellBackgroundLayeringVC : UITableViewController {

    let cellIdentifier = "Cell"

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    // window background is white
    // table view background is green (set in nib)

    /*
     the window background never appears
     the table view background appears when you "bounce" the scroll beyond its limits
     the red cell background color is behind the cell
     the linen cell background view is on top of that
     the (translucent, here) selected background view is on top of that
     the content view and its contents are on top of that
     */

    /*
     Simple "dequeue" (without "forIndexPath") might return a nil cell, and certainly will at the
     outset as the initial stack of reusable cells is needed. This means that everything in the code
     has to accommodate this possibility: the cell must be a var because you might need to create
     and assign it, the cell must be typed as an Optional, and all references to the cell must be
     unwrapped. This is annoying - and completely unnecessary. I'm only showing it here
     for illustrative purposes. For the rest of the book, I'll use dequeue...:forIndexPath: which
     has none of those issues, and the cell will never be an Optional (or nil) ever again.
     */

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier:cellIdentifier)

            cell.textLabel!.textColor = .white

            let v = UIImageView() // no need to set frame
            v.contentMode = .scaleToFill
            v.image = UIImage(named:"linen")
            cell.backgroundView = v

            let v2 = UIView() // no need to set frame
            v2.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            cell.selectedBackgroundView = v2
            // next line no longer necessary in iOS 7!
            // cell.textLabel.backgroundColor = .clear

            // next line didn't work until iOS 7!
            cell.backgroundColor = .red

            let b = UIButton(type:.system)
            b.setTitle("Tap Me", for:.normal)
            b.sizeToFit()
            // ... add action and target here ...
            cell.accessoryView = b

            cell.textLabel!.font = UIFont(name:"Helvetica-Bold", size:12.0)
        }
        cell.textLabel!.text = "Hello there! \(indexPath.row)"

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(cell.backgroundColor!) // no need to set it here in iOS 7...
        // ...the color set in cellForRow has held
        print(cell.textLabel?.backgroundColor as Any) // no need to set label background color to clear...
        // ...it is not being rejiggered
    }
    
    
}
