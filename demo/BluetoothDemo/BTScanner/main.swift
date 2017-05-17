//
//  main.swift
//  BTScanner
//
//  Created by wangkan on 2017/5/17.
//
//

import Foundation
import Cocoa
import IOBluetooth

var timeout = 10
var address = false
var name = false

class BlueDelegate : IOBluetoothDeviceInquiryDelegate {
    func deviceInquiryDeviceFound(_ sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
        if (address) {
            print(device.addressString + (name ? " " + device.name : ""))
        } else if (name) {
            print(device.name)
        } else {
            print(device.nameOrAddress)
        }
    }
}

var args = CommandLine.arguments
if args.count > 1 {
    for a in 1..<args.count {
        var i = a
        switch args[i] {
        case "-t":
            if args.count > i+1 {
                let t = args[i+1]
                timeout = Int(t)!
            }
        case "-a": address = true
        case "-n": name = true
        default:break
        }
    }
}

var delegate = BlueDelegate()
var inquiry = IOBluetoothDeviceInquiry(delegate: delegate)!
inquiry.updateNewDeviceNames = true
if (inquiry.start() == kIOReturnSuccess) {
    sleep(UInt32(timeout))
    inquiry.stop()
}

