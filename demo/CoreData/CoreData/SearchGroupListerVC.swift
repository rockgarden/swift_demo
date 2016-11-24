//
//  SearchGroupLister.swift
//  CoreDataExample
//
//  Created by wangkan on 2016/11/24.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import CoreData

class SearchGroupListerVC: UIViewController {
    
    @IBOutlet var dataView: UITextView!
    
    let context : NSManagedObjectContext! = {
        let context = App_Delegate.context
        return context
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func read() {
        do {
            var t = ""
            let person = try readData()
            let persons = try personsWith(atLeastOneCarWithMaker: "VW")
            if (persons != nil) {
                t = "\(persons?.count) have VW." + "\n" + "like " + person.firstName! + person.lastName!
            }
            var t1 = ""
            if let cars = person.cars?.allObjects as? [Car], cars.count > 0 {
                cars.enumerated().forEach{offset, car in
                    t1 = t1 + "Car: #\(offset + 1) \(car.maker!) \(car.model!)"
                }
            }
            dataView.text = nil
            dataView.text = t + "\n" + t1
        } catch {
            print("Could not write the data")
        }
    }
    
    func readData() throws -> Person {
        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        personFetchRequest.fetchLimit = 1
        personFetchRequest.relationshipKeyPathsForPrefetching = ["cars"]
        let persons = try context.fetch(personFetchRequest)
        guard let person = persons.first,
            persons.count == personFetchRequest.fetchLimit else {
                throw ReadDataExceptions.MoreThanOnePersonCameBack
        }
        return person
    }
    
    func personsWith(firstName fName: String,
                     lastName lName: String) throws -> [Person]? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "firstName == %@ && lastName == %@",
                                        argumentArray: [fName, lName])
        return try context.fetch(request)
    }
    
    func personsWith(firstNameFirstCharacter char: Character) throws -> [Person]? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "firstName LIKE[c] %@",
                                        argumentArray: ["\(char)*"])
        return try context.fetch(request)
    }
    
    func personsWith(atLeastOneCarWithMaker maker: String) throws -> [Person]? {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.relationshipKeyPathsForPrefetching = ["cars"]
        request.predicate = NSPredicate(format: "ANY cars.maker ==[c] %@",
                                        argumentArray: [maker])
        return try context.fetch(request)
    }

    @IBAction func write() {
        do {
            try writeManyPersonObjectsToDatabase({[weak self] in
                guard let strongSelf = self else {return}
                do{
                    let count = try strongSelf.countOfPersonObjectsWritten()
                    print(count)
                } catch {
                    print("Could not count the objects in the database")
                }

            })
        } catch {
            print("Could not write the data")
        }
    }

    /// 后台写入数据
    func writeManyPersonObjectsToDatabase(_ completion: @escaping () -> Void) throws {

        let context = App_Delegate.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true

        let group = Group(context: context)
        group.name = "many"
        group.uuid = NSUUID().uuidString
        group.timestamp = NSDate()
        do {
            try self.context.save()
        } catch {
            //catch the errors here
        }

        /* asynchronously performs the block on the context's queue.  Encapsulates an autorelease pool and a call to processPendingChanges */
        context.perform {
            let howMany = 999
            for index in 1...howMany {
                let person = Person(context: context)
                person.group = group
                person.firstName = "First name \(index)"
                person.lastName = "First name \(index)"
            }
            do {
                try context.save()
                DispatchQueue.main.async{completion()}
            } catch {
                //catch the errors here
            }
        }
    }

    func countOfPersonObjectsWritten() throws -> Int{
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.resultType = .countResultType
        guard let result = (try context.execute(request)
            as? NSAsynchronousFetchResult<NSNumber>)?
            .finalResult?
            .first as? Int else {return 0}
        return result
    }

}
