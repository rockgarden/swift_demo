//
//  Func.swift
//  Func
//
//  Created by wangkan on 2016/11/14.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import Foundation


func getIFAddresses() -> [String] {
    var addresses = [String]()
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        
        // For each interface ...
        for (var ptr = ifaddr; ptr != nil; ptr = ptr?.pointee.ifa_next) {
            let flags = Int32((ptr?.pointee.ifa_flags)!)
            var addr = ptr?.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String.init(validatingUTF8: hostname) {
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
