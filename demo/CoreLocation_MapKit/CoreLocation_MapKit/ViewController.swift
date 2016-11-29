//
//  ViewController.swift
//  CoreLocation_MapKit
//
//  Created by wangkan on 16/8/17.
//  Copyright © 2016年 rockgarden. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
	@IBOutlet weak var myMap: MKMapView!
    @IBOutlet var headingLab : UILabel!

	let locationManager = CLLocationManager()
	var myLatitude: CLLocationDegrees!
	var myLongitude: CLLocationDegrees!
	var finalLatitude: CLLocationDegrees!
	var finalLongitude: CLLocationDegrees!
	var distance: CLLocationDistance!
    var updating = false

	override func viewDidLoad() {
		super.viewDidLoad()
        
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()

		let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        self.myMap.delegate = self
		myMap.addGestureRecognizer(tap)
	}

	func action(_ gestureRecognizer: UIGestureRecognizer) {
		let touchPoint = gestureRecognizer.location(in: self.myMap)
		let newCoord: CLLocationCoordinate2D = myMap.convert(touchPoint, toCoordinateFrom: self.myMap)
		let getLat: CLLocationDegrees = newCoord.latitude
		let getLon: CLLocationDegrees = newCoord.longitude

		// Convert to points to CLLocation. In this way we can measure distanceFromLocation
		let newCoord2 = CLLocation(latitude: getLat, longitude: getLon)
		let newCoord3 = CLLocation(latitude: myLatitude, longitude: myLongitude)

		finalLatitude = newCoord2.coordinate.latitude
		finalLongitude = newCoord2.coordinate.longitude
		print("Original Latitude: \(myLatitude)")
		print("Original Longitude: \(myLongitude)")
		print("Final Latitude: \(finalLatitude)")
		print("Final Longitude: \(finalLongitude)")

		// distance between our position and the new point created
		let distance = newCoord2.distance(from: newCoord3)
		print("Distance between two points: \(distance)")

		let newAnnotation = MKPointAnnotation()
		newAnnotation.coordinate = newCoord
		newAnnotation.title = "My target"
		newAnnotation.subtitle = ""
		myMap.addAnnotation(newAnnotation)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in

			if (error != nil) {
				print("Reverse geocoder failed with error" + error!.localizedDescription)
				return
			}

			if placemarks!.count > 0 {
				let pm = placemarks![0] as CLPlacemark
				self.displayLocationInfo(pm)
			} else {
				print("Problem with the data received from geocoder")
			}
		})
	}

	func displayLocationInfo(_ placemark: CLPlacemark?) {
		if let containsPlacemark = placemark {
			// stop updating location to save battery life
			locationManager.stopUpdatingLocation()

			// get data from placemark
			let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
			let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
			let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
			let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
			myLongitude = (containsPlacemark.location!.coordinate.longitude)
			myLatitude = (containsPlacemark.location!.coordinate.latitude)

			// testing show data
			print("Locality: \(locality)")
			print("PostalCode: \(postalCode)")
			print("Area: \(administrativeArea)")
			print("Country: \(country)")
			print(myLatitude)
			print(myLongitude)

			// update map with my location
			let theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
			let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: myLatitude, longitude: myLongitude)
			let theRegion: MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)

			myMap.setRegion(theRegion, animated: true)
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error while updating location " + error.localizedDescription)
        self.doStop(nil)
	}

	// distance between two points
	func degreesToRadians(_ degrees: Double) -> Double { return degrees * M_PI / 180.0 }
	func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / M_PI }

	func getBearingBetweenTwoPoints1(_ point1: CLLocation, point2: CLLocation) -> Double {
		let lat1 = degreesToRadians(point1.coordinate.latitude)
		let lon1 = degreesToRadians(point1.coordinate.longitude)
		let lat2 = degreesToRadians(point2.coordinate.latitude);
		let lon2 = degreesToRadians(point2.coordinate.longitude);

		print("Start latitude: \(point1.coordinate.latitude)")
		print("Start longitude: \(point1.coordinate.longitude)")
		print("Final latitude: \(point2.coordinate.latitude)")
		print("Final longitude: \(point2.coordinate.longitude)")

		let dLon = lon2 - lon1;
		let y = sin(dLon) * cos(lat2);
		let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
		let radiansBearing = atan2(y, x);

		return radiansToDegrees(radiansBearing)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
    fileprivate var set = NSMutableArray()
}

extension ViewController {
    
    @IBAction func createAnotation(_ sender: AnyObject) {
        
        let a = MyAnotation(c: myMap.centerCoordinate, t: "Center", st: "The map center")
        _ = mapView(myMap, viewFor: a)
        myMap.addAnnotation(a)
        set.add(a)
    }
    
    @IBAction func deleteAnotation(_ sender: AnyObject) {
        //new for swift 2.0
        let annotationsToRemove = self.myMap.annotations
        self.myMap.removeAnnotations(annotationsToRemove)
    }
    
    @IBAction func coordinates(_ sender: AnyObject) {
        
        latitude.text = "\(myMap.centerCoordinate.latitude)"
        longitude.text = "\(myMap.centerCoordinate.longitude)"
    }
    
    @objc(mapView:viewForAnnotation:) func mapView(_ mapView: MKMapView, viewFor annotation:
        MKAnnotation) -> MKAnnotationView?{
        let pinView:MKPinAnnotationView = MKPinAnnotationView(annotation:
            annotation, reuseIdentifier: "Custom")
        //purple color to anotation
        //pinView.pinColor = MKPinAnnotationColor.Purple
        pinView.image = UIImage(named:"mypin.png")
        return pinView
    }

}

extension ViewController {

    @IBAction func doStart (_ sender: Any!) {
        guard CLLocationManager.headingAvailable() else {return} // no hardware
        if self.updating {doStop(nil); return}
        if self.locationManager.delegate == nil {self.locationManager.delegate = self}

        print("starting")
        self.locationManager.headingFilter = 5
        self.locationManager.headingOrientation = .portrait
        self.updating = true
        // NO AUTH NEEDED!
        // the heading part works just fine even if Location Services is turned off
        // and if it is turned on, we will get true-north
        // seems like a major bug to me
        self.locationManager.startUpdatingHeading()
    }

    func doStop (_ sender: Any!) {
        self.locationManager.stopUpdatingHeading()
        self.headingLab.text = ""
        self.updating = false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var h = newHeading.magneticHeading
        let h2 = newHeading.trueHeading // -1 if no location info
        print("\(h) \(h2) ")
        if h2 >= 0 {
            h = h2
        }
        let cards = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        var dir = "N"
        for (ix, card) in cards.enumerated() {
            if h < 45.0/2.0 + 45.0*Double(ix) {
                dir = card
                break
            }
        }
        if self.headingLab.text != dir {
            self.headingLab.text = dir
        }
        print(dir)
    }

    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        print("he asked me, he asked me")
        return true // if you want the calibration dialog to be able to appear
    }

}


