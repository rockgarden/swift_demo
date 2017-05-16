/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The application's main (initial) view controller.
 */

import UIKit

class Main_NavigationBar: UITableViewController, UIActionSheetDelegate {
    
    struct ActionSheetOption {
        static let standard = 1
        static let blackOpaque = 2
        static let blackTranslucent = 3
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    /**
     *  Unwind action that is targeted by the demos which present a modal view
     *  controller, to return to the main screen.
     */
    @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue) { }
    
    // MARK: - Style Action Sheet
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        // Change the navigation bar style
        switch buttonIndex {
        case ActionSheetOption.standard:
            navigationController!.navigationBar.barStyle = .default
            // Bars are translucent by default.
            navigationController!.navigationBar.isTranslucent = true
            // Reset the bar's tint color to the system default.
            navigationController!.navigationBar.tintColor = nil
            
        case ActionSheetOption.blackOpaque:
            navigationController!.navigationBar.barStyle = .black
            navigationController!.navigationBar.isTranslucent = false
            navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
            
        case ActionSheetOption.blackTranslucent:
            navigationController!.navigationBar.barStyle = .black
            navigationController!.navigationBar.isTranslucent = true
            navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
            
        default:
            break
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    /**
     *  IBAction for the 'Style' bar button item.
     */
    @IBAction func styleAction(_ sender: AnyObject) {
        let title = NSLocalizedString("Choose a UIBarStyle:", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let defaultButtonTitle = NSLocalizedString("Default", comment: "")
        let blackOpaqueTitle = NSLocalizedString("Black Opaque", comment: "")
        let blackTranslucentTitle = NSLocalizedString("Black Translucent", comment: "")
        
        let styleSheet = UIActionSheet(title: title, delegate: self, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil, otherButtonTitles: defaultButtonTitle, blackOpaqueTitle, blackTranslucentTitle)
        
        // use the same style as the nav bar
        styleSheet.actionSheetStyle = UIActionSheetStyle(rawValue: self.navigationController!.navigationBar.barStyle.rawValue)!
        
        styleSheet.show(in: view)
    }


    struct CellModel {
        let name = "manny"
        var visible = true
    }
    var model = [CellModel()]
    var lastSelection = IndexPath()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let id = cell?.tag {
            if indexPath.section == 0 && id == 0 {
                model[indexPath.row].visible = false
                tableView.reloadRows(at: [indexPath], with: .none)
                lastSelection = indexPath
                performSegue(withIdentifier: "showDetail", sender: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.tableView.indexPathForSelectedRow as Any)
        if let dest = segue.destination as? ImageDetailVC {
            let cm = model[lastSelection.row]
            dest.detailItem = UIImage(named:cm.name)
        }
    }

}


class ImageDetailVC : UIViewController {
    var detailItem : Any?
    @IBOutlet var iv : UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let im = self.detailItem as? UIImage {
            self.iv.image = im
        }

        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)

        if let tc = self.transitionCoordinator {
            print(tc)
        }

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator {
            print(tc)
        }

    }

}

