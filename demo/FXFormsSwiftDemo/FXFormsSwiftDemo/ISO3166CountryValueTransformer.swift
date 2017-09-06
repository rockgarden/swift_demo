//
//  ISO3166CountryValueTransformer.swift
//  SwiftExample
//
//  Created by Nick Lockwood on 29/09/2014.
//  Copyright (c) 2014 Nick Lockwood. All rights reserved.
//

import UIKit

class ISO3166CountryValueTransformer: ValueTransformer {
   
    override class func transformedValueClass() -> AnyClass {
        
        return NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        
        if value != nil {
            return (Locale(identifier: "en_US") as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value:value!) ?? value
        }
        return nil
    }
}
