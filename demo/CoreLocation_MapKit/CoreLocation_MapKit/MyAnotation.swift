//
//  MyAnotation.swift
//  MapKit iPad
//
//  Created by Carlos Butron on 12/04/15.
//  Copyright (c) 2014 Carlos Butron.
//

import UIKit
import MapKit

class MyAnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    func getTitle() -> NSString{
        return self.title!
    }
    func getSubTitle() -> NSString {
        return self.subtitle!
    }
    init(c:CLLocationCoordinate2D, t:String, st: String){
        coordinate = c
        title = t
        subtitle = st
    }
}
