//
//  ParseXmlVC.swift
//  FileOperations
//
//  Created by wangkan on 2016/11/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ParseXmlVC: UIViewController {
    
    // if this works, you'll see a list of people appear in the console
    
    @IBAction func doButton (_ sender: Any!) {
        if let url = Bundle.main.url(forResource:"folks", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: url) {
                let people = MyPeopleParser(name: "", parent: nil)
                parser.delegate = people
                parser.parse()
                
                // ... done, do something with people.people ...
                print(people.people)
            }
        }
    }
    
    
}
