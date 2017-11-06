//
//  main.swift
//  CommandLineToolDemo
//
//  Created by wangkan on 2017/11/6.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

import Foundation

print("Hello, World!")
start()
/// swift中直接调用 echo、mkdir、cd 命令
///
/// - Parameters:
///   - path:
///   - arguments:
/// - Returns:
func execute(path: String, arguments: [String]? = nil) -> Int {
    let process = Process()
    process.launchPath = path
    if arguments != nil {
        process.arguments = arguments!
    }
    process.launch()
    process.waitUntilExit()
    return Int(process.terminationStatus)
}

let status = execute(path: "/bin/ls")
print("Status = \(status)")
//以上的脚本相当于在终端中执行了ls命令，如果大家不知道命令的路径的话，可以用where查找一下，例如：
//where ls
//
//这是执行后的结果：
//
//ls: aliased to ls -G
///bin/ls
//
//这里的/bin/ls就是ls命令的路径。

