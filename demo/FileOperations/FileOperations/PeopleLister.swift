

import UIKit

class PeopleLister: UITableViewController, UITextFieldDelegate {
    
    let fileURL : URL
    var doc : PeopleDocument!
    var people : [Person] { // point to the document's model object
        get { return self.doc.people }
        set { self.doc.people = newValue }
    }

    init(fileURL: URL) {
        self.fileURL = fileURL
        super.init(nibName: "PeopleLister", bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = (self.fileURL.lastPathComponent as NSString)
            .deletingPathExtension
        let b = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAdd))
        self.navigationItem.rightBarButtonItems = [b]
        
        self.tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "Person")
        
        let fm = FileManager.default
        self.doc = PeopleDocument(fileURL: self.fileURL) //super class init func
        
        func listPeople(_ success:Bool) {
            if success {
                // self.people = self.doc.people as NSArray as [Person]
                self.tableView.reloadData()
            }
        }
        if !fm.fileExists(atPath:self.fileURL.path) {
            self.doc.save(to:self.doc.fileURL,
                for: .forCreating,
                completionHandler: listPeople)
        } else {
            self.doc.open(completionHandler:listPeople)
        }
    }
    
    func doAdd (_ sender: Any) {
        self.tableView.endEditing(true)
        let newP = Person(firstName: "", lastName: "")
        self.people.append(newP)
        let ct = self.people.count
        let ix = IndexPath(row:ct-1, section:0)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at:ix, at:.bottom, animated:true)
        let cell = self.tableView.cellForRow(at:ix)!
        let tf = cell.viewWithTag(1) as! UITextField
        tf.becomeFirstResponder()
        
        self.doc.updateChangeCount(.done)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.doc == nil {
            print("doc was nil")
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("self.people was \(self.people)")
        return self.people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Person", for: indexPath)
        let first = cell.viewWithTag(1) as! UITextField
        let last = cell.viewWithTag(2) as! UITextField
        let p = self.people[indexPath.row]
        first.text = p.firstName
        last.text = p.lastName
        first.delegate = self
        last.delegate = self
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end editing")
        var v = textField.superview!
        while !(v is UITableViewCell) {v = v.superview!}
        let cell = v as! UITableViewCell
        let ip = self.tableView.indexPath(for:cell)!
        let row = ip.row
        let p = self.people[row]
        p.setValue(textField.text!, forKey: textField.tag == 1 ? "firstName" : "lastName")
        
        self.doc.updateChangeCount(.done)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.tableView.endEditing(true)
        self.people.remove(at:indexPath.row)
        tableView.deleteRows(at:[indexPath], with:.automatic)
        
        self.doc.updateChangeCount(.done)
    }
    
    func forceSave(_: Any?) {
        print("force save")
        self.tableView.endEditing(true)
        self.doc.save(to:self.doc.fileURL, for:.forOverwriting)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(forceSave), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.forceSave(nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
