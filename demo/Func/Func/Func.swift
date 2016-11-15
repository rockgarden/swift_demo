//
//  Func.swift
//  Func
//
//  Created by wangkan on 2016/11/14.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation

func get_ifaddrs() -> ([String], String?) {
    
    var addresses = [String]()
    var addressWiFi : String?
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    guard getifaddrs(&ifaddr) == 0 else { return ([], addressWiFi) }
    guard let firstAddr = ifaddr else { return ([], addressWiFi) }
    
    // For each interface ...
    /// pointee 指针数据
    for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        
        let interface = ptr.pointee
        let flags = Int32((ptr.pointee.ifa_flags))
        var addr = ptr.pointee.ifa_addr.pointee
        
        // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
        if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    addressWiFi = String(cString: hostname)
                }
                
                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if (getnameinfo(&addr, socklen_t((addr.sa_len)), &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                    if let address = String.init(validatingUTF8: hostname) {
                        addresses.append(address)
                    }
                }
            }
        }
    }
    freeifaddrs(ifaddr)
    return (addresses, addressWiFi)
}


typealias address = (name: String, ip: String)
func get_ifaddrs_list() -> [address]? {
    var addresses = [address]()
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    
    // For each interface ...
    /// pointee 指针数据
    for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        
        let interface = ptr.pointee
        let flags = Int32((ptr.pointee.ifa_flags))
        var addr = ptr.pointee.ifa_addr.pointee
        
        // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
        if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if (getnameinfo(&addr, socklen_t((addr.sa_len)), &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                    if let address = String.init(validatingUTF8: hostname) {
                        let name = String(cString: interface.ifa_name)
                        addresses.append(name: name, ip: address)
                    }
                }
            }
        }
    }
    freeifaddrs(ifaddr)
    return addresses
}


func remoteIP(_ url: String) -> String? {
    var an_Integer : Int
    var ipItemsArray: [String]
    var externalIP : String?
    let iPURL = URL(string: url)
    
    if (iPURL != nil) {
        var error: NSError? = nil
        var theIpHtml: String?
        do {
            theIpHtml = try String(contentsOf: iPURL!, encoding: String.Encoding.utf8)
        } catch let aError as NSError {
            error = aError
        }
        
        if (!(error != nil)) {
            var theScanner: Scanner
            var text : NSString?
            theScanner = Scanner(string: theIpHtml!)
            
            while (theScanner.isAtEnd == false) {
                
                // find start of tag
                theScanner.scanUpTo("<", into: nil)
                
                // find end of tag
                text = nil
                theScanner.scanUpTo(">", into: &text)
                
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)                
                theIpHtml = theIpHtml?.replacingOccurrences(of: ">\(text)", with: " ")
                
                ipItemsArray = (theIpHtml?.components(separatedBy: " "))!
                
                if ipItemsArray.index(of: "Address:") != nil {
                    an_Integer = ipItemsArray.index(of: "Address:")!
                    externalIP = ipItemsArray[an_Integer+1]
                }
                
            }
        } else {
            NSLog("Oops... g %ld, %@", (error?.code)! as CLong, error?.localizedDescription ?? "unknow error")
        }
    }
    return externalIP
}


/** swift 2.3
 func getIFAddresses() -> [String] {
 var addresses = [String]()
 var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
 if getifaddrs(&ifaddr) == 0 {
 
 // For each interface ...
 for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
 let flags = Int32(ptr.memory.ifa_flags)
 var addr = ptr.memory.ifa_addr.memory
 
 // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
 if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
 if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
 
 // Convert interface address to a human readable string:
 var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
 if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
 nil, socklen_t(0), NI_NUMERICHOST) == 0) {
 if let address = String.fromCString(hostname) {
 addresses.append(address)
 }
 }
 }
 }
 }
 freeifaddrs(ifaddr)
 }
 print("Local IP \(addresses)")
 return addresses
 }
 */

/**
 // Return IP address of WiFi interface (en0) as a String, or `nil`
 func getWiFiAddress() -> String? {
 var address : String?
 
 // Get list of all interfaces on the local machine:
 var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
 if getifaddrs(&ifaddr) == 0 {
 
 // For each interface ...
 var ptr = ifaddr
 while ptr != nil {
 defer { ptr = ptr.memory.ifa_next }
 
 let interface = ptr.memory
 
 // Check for IPv4 or IPv6 interface:
 let addrFamily = interface.ifa_addr.memory.sa_family
 if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
 
 // Check interface name:
 if let name = String.fromCString(interface.ifa_name) where name == "en0" {
 
 // Convert interface address to a human readable string:
 var addr = interface.ifa_addr.memory
 var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
 getnameinfo(&addr, socklen_t(interface.ifa_addr.memory.sa_len),
 &hostname, socklen_t(hostname.count),
 nil, socklen_t(0), NI_NUMERICHOST)
 address = String.fromCString(hostname)
 }
 }
 }
 freeifaddrs(ifaddr)
 }
 
 return address
 }
 */
