//
//  LocationMethods.swift
//  MemoryInMap
//
//  Created by wangkan on 16/6/15.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import UIKit
import MapKit

func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(action)
    viewController.presentViewController(alert, animated: true, completion: nil)
}

func zoomToUserLocationInMapView(mapView: MKMapView) {
    if let coordinate = mapView.userLocation.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
}

func zoomToUserLocationInMapView(mapView: MKMapView, locationManager: CLLocationManager) {
    if let coordinate = mapView.userLocation.location?.coordinate {
        let GCJcood = locationManager.WGSToGCJ(coordinate)
        let region = MKCoordinateRegionMakeWithDistance(GCJcood, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
}

