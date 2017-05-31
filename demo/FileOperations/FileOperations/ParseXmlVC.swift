//
//  ParseXmlVC.swift
//  FileOperations
//
//  Created by wangkan on 2016/11/23.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit

class ParseXmlVC: UIViewController {

    @IBOutlet var tv: UITextField!
    
    @IBAction func doButton (_ sender: Any!) {
        if let url = Bundle.main.url(forResource:"folks", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: url) {
                let people = MyPeopleParser(name: "", parent: nil)
                parser.delegate = people
                parser.parse()
                tv.text = people.people.description
            }
        }
    }
    
    
}
