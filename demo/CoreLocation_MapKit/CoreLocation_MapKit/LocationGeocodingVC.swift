
import UIKit
import MapKit
import AddressBookUI
import Contacts

func delay(_ delay: Double, closure: @escaping()->()) {
    let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: closure)
}

class LocationGeocodingVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    @IBOutlet var map : MKMapView!
    let locman = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        let bbi = MKUserTrackingBarButtonItem(mapView:self.map)
        self.toolbarItems = [bbi]

        let sb = UISearchBar()
        sb.sizeToFit()
        sb.searchBarStyle = .minimal
        sb.delegate = self
        self.navigationItem.titleView = sb

        self.map.delegate = self
    }

    @IBAction func doButton (sender:AnyObject!) {
        let mi = MKMapItem.forCurrentLocation()
        // setting the span doesn't seem to work
        // let span = MKCoordinateSpanMake(0.0005, 0.0005)
        mi.openInMaps(launchOptions: [
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue,
            // MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan:span)
            ])
    }

    @IBAction func doButton2 (sender:AnyObject!) {
        // new in iOS 8, can't simply switch this on
        // must request authorization first
        // and this request will be ignored without a corresponding reason in the Info.plist
        // (see next chapter for full dance)
        self.locman.requestWhenInUseAuthorization()
        // self.map.showsUserLocation = true // otiose (I love that word)
        self.map.userTrackingMode = .follow // will cause map to zoom nicely to user location
        // (the thing I was doing before, adjusting the map region manually, was just wrong)
    }

    @IBAction func reportAddress (sender:AnyObject!) {
        guard let loc = self.map.userLocation.location else {
            print("I don't know where you are now")
            return
        }
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(loc) {
            placemarks,error in
            guard let ps = placemarks , ps.count > 0 else {return}
            let p = ps[0]
            if let d = p.addressDictionary {
                if let add = d["FormattedAddressLines"] as? [String] {
                    for line in add {
                        print(line)
                    }
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let s = searchBar.text
        if s == nil || s!.characters.count < 5 { return }
        let geo = CLGeocoder()
        geo.geocodeAddressString(s!) {
            placemarks,error in
            guard let placemarks = placemarks else {
                print(error?.localizedDescription)
                return
            }
            self.map.showsUserLocation = false
            let p = placemarks[0]
            let mp = MKPlacemark(placemark:p)
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotation(mp)
            self.map.setRegion(
                MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000, 1000),
                animated: true)
        }
    }

    @IBAction func thaiFoodNearMapLocation (sender:AnyObject!) {
        guard let loc = self.map.userLocation.location else {
            print("I don't know where you are now")
            return
        }
        let req = MKLocalSearchRequest()
        req.naturalLanguageQuery = "Thai restaurant"
        req.region = MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(1,1))
        let search = MKLocalSearch(request:req)
        search.start {
            response,error in
            guard let response = response else {
                print(error)
                return
            }
            self.map.showsUserLocation = false
            let mi = response.mapItems[0] // I'm feeling lucky
            let place = mi.placemark
            let loc = place.location!.coordinate
            let reg = MKCoordinateRegionMakeWithDistance(loc, 1200, 1200)
            self.map.setRegion(reg, animated:true)
            let ann = MKPointAnnotation()
            ann.title = mi.name
            ann.subtitle = mi.phoneNumber
            ann.coordinate = loc
            self.map.addAnnotation(ann)
        }
    }

    @IBAction func directionsToThaiFood (sender:AnyObject!) {
        let userLoc = self.map.userLocation
        let loc = userLoc.location
        if loc == nil {
            print("I don't know where you are now")
            return
        }
        let req = MKLocalSearchRequest()
        req.naturalLanguageQuery = "Thai restaurant"
        req.region = self.map.region
        let search = MKLocalSearch(request:req)
        search.start {
            response,error in
            guard let response = response else {
                print(error)
                return
            }
            print("Got restaurant address")
            let mi = response.mapItems[0] // I'm still feeling lucky
            let req = MKDirectionsRequest()
            req.source = MKMapItem.forCurrentLocation()
            req.destination = mi
            let dir = MKDirections(request:req)
            dir.calculate {
                response,error in
                guard let response = response else {
                    print(error)
                    return
                }
                print("got directions")
                let route = response.routes[0] // I'm feeling insanely lucky
                let poly = route.polyline
                self.map.add(poly)
                for step in route.steps {
                    print("After \(step.distance) metres: \(step.instructions)")
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolyline {
            let v = MKPolylineRenderer(polyline:overlay)
            v.strokeColor = .blue //.blue.WithAlphaComponent(0.8)
            v.lineWidth = 2
            return v
        }
        return MKOverlayRenderer()
    }
    
}
