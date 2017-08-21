
import UIKit
import Contacts
import ContactsUI


func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

func checkForContactsAccess(andThen f:(()->())? = nil) {
    let status = CNContactStore.authorizationStatus(for:.contacts)
    switch status {
    case .authorized:
        f?()
    case .notDetermined:
        CNContactStore().requestAccess(for:.contacts) { ok, err in
            if ok {
                DispatchQueue.main.async {
                    f?()
                }
            }
        }
    case .restricted:
        // do nothing
        break
    case .denied:
        // do nothing, or beg the user to authorize us in Settings
        print("denied")
        break
    }
}

class ContactsVC : UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ignore Me", style: .plain, target: nil, action: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func doFindMoi (_ sender: Any!) {
        checkForContactsAccess {
            DispatchQueue.global(qos: .userInitiated).async {
                var which : Int {return 2} // 1 or 2
                do {
                    var premoi : CNContact!
                    switch which {
                    case 1:
                        /**
                         CNContactStore类是一个线程安全的类，可以获取和保存联系人，组和容器。
                         CNContactStore类提供了执行抓取和保存请求的方法。 您可以通过几种推荐方法在应用中实施这些请求来加载联系人：
                         仅获取将要使用的联系人属性。
                         获取所有联系人并缓存结果时，请先获取所有联系人标识符，然后根据需要通过标识符获取批量的详细联系人。
                         要聚合几个联系人提取，首先从提取中收集一组唯一标识符。 然后通过这些唯一标识符获取批量的详细联系人。
                         如果缓存获取的联系人，组或容器，则在发布CNContactStoreDidChangeNotification时需要重新读取这些对象（并释放旧的缓存对象）。
                         因为CNContactStore提取方法执行I / O，建议您避免使用主线程执行提取。
                         */
                        let pred = CNContact.predicateForContacts(matchingName:"Matt")
                        var matts = try CNContactStore().unifiedContacts(matching:pred, keysToFetch: [
                            CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor
                            ])
                        matts = matts.filter{$0.familyName == "Neuburg"}
                        guard let moi = matts.first else {
                            print("couldn't find myself")
                            return
                        }
                        premoi = moi
                    case 2:
                        /**
                         定义提取选项以在获取联系人时使用的对象。
                         您需要至少一个联系人属性键来获取联系人的属性。 使用这个类与enumerateContacts（with：usingBlock :)方法来执行联系提取请求。
                         */
                        let pred = CNContact.predicateForContacts(matchingName:"k")
                        let req = CNContactFetchRequest(keysToFetch: [
                            CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor
                            ])
                        req.predicate = pred
                        var matt : CNContact? = nil
                        try CNContactStore().enumerateContacts(with:req) {
                            con, stop in
                            if con.familyName == "w" {
                                matt = con
                                stop.pointee = true
                            }
                        }
                        guard let moi = matt else {
                            print("couldn't find myself")
                            return
                        }
                        premoi = moi
                    default:break
                    }
                    var moi = premoi!
                    print(moi)
                    if moi.isKeyAvailable(CNContactEmailAddressesKey) {
                        print(moi.emailAddresses)
                    } else {
                        print("you haven't fetched emails yet")
                    }
                    moi = try CNContactStore().unifiedContact(withIdentifier: moi.identifier, keysToFetch: [CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
                    let emails = moi.emailAddresses
                    let workemails = emails.filter{$0.label == CNLabelWork}.map{$0.value}
                    guard workemails.count != 0 else {return}
                    print(workemails)
                    let full = CNContactFormatterStyle.fullName
                    let keys = CNContactFormatter.descriptorForRequiredKeys(for:full)
                    moi = try CNContactStore().unifiedContact(withIdentifier: moi.identifier, keysToFetch: [keys, CNContactEmailAddressesKey as CNKeyDescriptor])
                    if let name = CNContactFormatter.string(from: moi, style: full) {
                        print("\(name): \(workemails[0])")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }


    @IBAction func doCreateSnidely (_ sender: Any!) {
        checkForContactsAccess {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let snidely = CNMutableContact()
                    snidely.givenName = "Snidely"
                    snidely.familyName = "Whiplash"
                    let email = CNLabeledValue(label: CNLabelHome, value: "snidely@villains.com" as NSString)
                    snidely.emailAddresses.append(email)
                    snidely.imageData = UIImagePNGRepresentation(UIImage(named:"snidely")!)
                    let save = CNSaveRequest()
                    save.add(snidely, toContainerWithIdentifier: nil)
                    try CNContactStore().execute(save)
                    print("created snidely!")
                } catch {
                    print(error)
                }
            }
        }
    }

    @IBAction func doPeoplePicker (_ sender: Any!) {
        checkForContactsAccess {
            let picker = CNContactPickerViewController()
            picker.delegate = self
            do {
                picker.displayedPropertyKeys = [CNContactEmailAddressesKey]
                picker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'emailAddresses'")
                picker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
                picker.predicateForSelectionOfContact = NSPredicate(format: "emailAddresses.@count > 0")
            }
            self.present(picker, animated:true)
        }
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect prop: CNContactProperty) {
        print("prop")
        print(prop)
    }

    @IBAction func doViewPerson (_ sender: Any!) {
        //  if we have authorization, get the contact from the database
        //  if we don't, get it from user defaults
        //  in this way, we discover whether the view controller can be used without authorization
        //  hint: yes it can
        DispatchQueue.global(qos: .userInitiated).async {
            var snide : CNContact!
            let status = CNContactStore.authorizationStatus(for:.contacts)
            if status == .authorized {
                print("getting from store")
                do {
                    let pred = CNContact.predicateForContacts(matchingName: "Snidely")
                    let keys = CNContactViewController.descriptorForRequiredKeys()
                    let snides = try CNContactStore().unifiedContacts(matching: pred, keysToFetch: [keys])
                    guard let snide1 = snides.first else {
                        print("no snidely")
                        return
                    }
                    snide = snide1
                    let d = NSKeyedArchiver.archivedData(withRootObject: snide)
                    let ud = UserDefaults.standard
                    ud.set(d, forKey:"snide")
                } catch {
                    print (error)
                }
            }
            else {
                print("getting from defaults")
                let ud = UserDefaults.standard
                if let d = ud.object(forKey: "snide") as? Data {
                    if let snide1 = NSKeyedUnarchiver.unarchiveObject(with: d) as? CNContact {
                        snide = snide1
                    }
                }
            }

            let vc = CNContactViewController(for:snide)
            vc.delegate = self
            vc.message = "Nyah ah ahhh"
            vc.allowsActions = false
            vc.highlightProperty(withKey: CNContactEmailAddressesKey, identifier: CNLabelHome)
            vc.contactStore = nil // TODO: no effect, can't prevent saving?
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func contactViewController(_ vc: CNContactViewController, didCompleteWith con: CNContact?) {
        print(con as Any)
        dismiss(animated: true) // TODO: needed for `forNewContact`, does no harm in the others?
    }

    func contactViewController(_ vc: CNContactViewController, shouldPerformDefaultActionFor prop: CNContactProperty) -> Bool {
        print("tapped \(prop)")
        return false
    }

    @IBAction func doNewPerson (_ sender: Any!) {
        let con = CNMutableContact()
        con.givenName = "Dudley"
        con.familyName = "Doright"
        let npvc = CNContactViewController(forNewContact: con)
        npvc.delegate = self
        present(UINavigationController(rootViewController: npvc), animated:true)
    }

    @IBAction func doUnknownPerson (_ sender: Any!) {
        let con = CNMutableContact()
        con.givenName = "Johnny"
        con.familyName = "Appleseed"
        con.phoneNumbers.append(CNLabeledValue(label: "woods", value: CNPhoneNumber(stringValue: "555-123-4567")))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.message = "He knows his trees"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = true
        //unkvc.displayedPropertyKeys = []
        navigationController?.pushViewController(unkvc, animated: true)
    }
}

