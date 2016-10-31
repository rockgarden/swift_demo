//
//  FuncLabel.swift
//  UILabel
//
//  Created by wangkan on 2016/10/31.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation

/**
 as 2^2•3•5^2 and returns 2²•3•5²
 */
func exponentize(str: String) -> String {
    let supers = [
        "1": "\u{00B9}",
        "2": "\u{00B2}",
        "3": "\u{00B3}",
        "4": "\u{2074}",
        "5": "\u{2075}",
        "6": "\u{2076}",
        "7": "\u{2077}",
        "8": "\u{2078}",
        "9": "\u{2079}"]

    var newStr = ""
    var isExp = false
    for (_, char) in str.characters.enumerated() {
        if char == "^" {
            isExp = true
        } else {
            if isExp {
                let key = String(char)
                if supers.keys.contains(key) {
                    newStr.append(Character(supers[key]!))
                } else {
                    isExp = false
                    newStr.append(char)
                }
            } else {
                newStr.append(char)
            }
        }
    }
    return newStr
}

