//
//  PrincipleViewController.swift
//  TestKVOKVC
//
//  Created by yangjun zhu on 15/9/12.
//  Copyright © 2015年 Cactus. All rights reserved.
//

import UIKit

class PrincipleViewController: UIViewController {
    let people = People(name: "Owen", age: 1, sex: 1, address: Address())
    let namePeople = People(name: "Owen", age: 1, sex: 1, address: Address())
    let nameAgePeople = People(name: "Owen", age: 1, sex: 1, address: Address())
    
    deinit{
        self.namePeople .removeObserver(self, forKeyPath: "name")
        self.nameAgePeople .removeObserver(self, forKeyPath: "name")
        self.nameAgePeople .removeObserver(self, forKeyPath: "age")
        
        
    }
    
    private var myContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.namePeople.addObserver( self, forKeyPath: "name", options: NSKeyValueObservingOptions([.New, .Old]), context: &myContext)
        self.nameAgePeople.addObserver( self, forKeyPath: "name", options: NSKeyValueObservingOptions([.New, .Old]), context: &myContext)
        self.nameAgePeople.addObserver( self, forKeyPath: "age", options: NSKeyValueObservingOptions([.New, .Old]), context: &myContext)
        self.printDescription("people", obj: people)
        self.printDescription("namePeople",obj: namePeople)
        self.printDescription("nameAgePeople",obj: nameAgePeople)
        

        print(self.people.methodForSelector(Selector("setName:")) )
        print(self.namePeople.methodForSelector(Selector("setName:")) )
        print(method_getImplementation(class_getInstanceMethod(object_getClass(self.people),Selector("setName:"))))
        print(method_getImplementation(class_getInstanceMethod(object_getClass(self.namePeople),Selector("setName:"))))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    private func classMethodNames(c: AnyObject) -> [String]
    {
        var arr = [String]()
        var methodCount: CUnsignedInt = 0;
        let methodList = class_copyMethodList(object_getClass(c), &methodCount);
        
        for i in 0...methodCount {
            arr.append( NSStringFromSelector(method_getName(methodList[Int(i)])))
        }
        
        free(methodList);
        
        return arr;
    }
    
    private func printDescription(objectName: String, obj: AnyObject)
    {
        print("-----------------start------------")
        print("对象变量名字：",objectName)
        print("对象：",obj)
        print("类：",NSStringFromClass(obj.classForCoder))
        print("元类：",NSStringFromClass(object_getClass(obj)))
        print("实现的方法：",self.classMethodNames(obj).joinWithSeparator(", "))
        print("-----------------end------------")
        
    }
    

    
}
