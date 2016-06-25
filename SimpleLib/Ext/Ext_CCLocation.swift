//
//  Ext_CCLocation.swift
//  Lambert To WGS84 & 地球坐标(WGS84)->火星坐标(GCJ-02)
//
//  Created by wangkan on 16/6/14.
//  Copyright © 2016年 Rockgarden. All rights reserved.
//

import CoreLocation
import Darwin

// MARK: - LambertToWGS84

/// Constant for Lambert
let E_CLARK_IGN: Double = 0.08248325676
let E_WGS84: Double = 0.08181919106
let A_CLARK_IGN: Double = 6378249.2
let A_WGS84: Double = 6378137.0

let LON_MERID_PARIS: Double = 0
let LON_MERID_GREENWICH: Double = 0.04079234433
let LON_MERID_IERS: Double = (3 * M_PI / 180)

/// Enum grouping all element about zones.
public enum LambertZone: Int {
	case I = 0
	case II
	case III
	case IV
	case II_E
	case L93
	var n: Double {
		get {
			switch self {
			case .I: return 0.7604059656
			case .II: return 0.7289686274
			case .III: return 0.6959127966
			case .IV: return 0.6712679322
			case .II_E: return 0.7289686274
			case .L93: return 0.7256077650
			}
		}
	}
	var c: Double {
		get {
			switch self {
			case .I: return 11603796.98
			case .II: return 11745793.39
			case .III: return 11947992.52
			case .IV: return 12136281.99
			case .II_E: return 11745793.39
			case .L93: return 11754255.426
			}
		}
	}
	var xs: Double {
		get {
			switch self {
			case .I: return 600000.0
			case .II: return 600000.0
			case .III: return 600000.0
			case .IV: return 234.358
			case .II_E: return 600000.0
			case .L93: return 700000.0
			}
		}
	}
	var ys: Double {
		get {
			switch self {
			case .I: return 5657616.674
			case .II: return 6199695.768
			case .III: return 6791905.085
			case .IV: return 7239161.542
			case .II_E: return 8199695.768
			case .L93: return 12655612.050
			}
		}
	}
}

internal struct Point {
	var x: Double
	var y: Double
	var z: Double
}

internal let EPS = 10e6

internal func latitudeISOFromLatitude(lat: Double, e: Double) -> Double {
	return log(tan(M_PI_4 + lat / 2) * pow((1 - e * sin(lat)) / (1 + e * sin(lat)), e / 2));
}

internal func latitudeFromLatitudeISO(lat_iso: Double, e: Double, eps: Double) -> Double {
	var phi_0: Double = 2 * atan(exp(lat_iso)) - M_PI_2
	var phi_i: Double = 2 * atan(pow((1 + e * sin(phi_0)) / (1 - e * sin(phi_0)), e / 2.0) * exp(lat_iso)) - M_PI_2
	var delta: Double = 1000
	while (delta > EPS) {
		phi_0 = phi_i
		phi_i = 2 * atan(pow((1 + e * sin(phi_0)) / (1 - e * sin(phi_0)), e / 2.0) * exp(lat_iso)) - M_PI_2
		delta = fabs(phi_i - phi_0)
	}
	return phi_i
}

internal func lamberToGeographic(org: Point, zone: LambertZone, lon_merid: Double, e: Double, eps: Double) -> Point {
	let n = zone.n
	let C = zone.c
	let x_s = zone.xs
	let y_s = zone.ys
	let x = org.x
	let y = org.y
	let x2 = (x - x_s) * (x - x_s)
	let y2 = (y - y_s) * (y - y_s)
	let R = sqrt(x2 + y2);
	let gamma = atan((x - x_s) / (y_s - y))
	let lon = lon_merid + gamma / n
	let lat_iso = -1 / n * log(fabs(R / C))
	return Point(x: lon, y: latitudeFromLatitudeISO(lat_iso, e: e, eps: eps), z: 0)
}

internal func lambertNormal(lat: Double, a: Double, e: Double) -> Double {
	return a / sqrt(1 - e * e * sin(lat) * sin(lat))
}

internal func geographicToCartesian(lon: Double, lat: Double, he: Double, a: Double, e: Double) -> Point {
	let N = lambertNormal(lat, a: a, e: e)
	var pt = Point(x: 0, y: 0, z: 0)
	pt.x = (N + he) * cos(lat) * cos(lon)
	pt.y = (N + he) * cos(lat) * sin(lon)
	pt.z = (N * (1 - e * e) + he) * sin(lat)
	return pt
}

internal func cartesianToGeographic(org: Point, meridian: Double, a: Double, e: Double, eps: Double) -> Point {
	let x = org.x, y = org.y, z = org.z;
	let lon = meridian + atan(y / x)
	let module = sqrt(x * x + y * y)
	var phi_0 = atan(z / (module * (1 - (a * e * e) / sqrt(x * x + y * y + z * z))));
	let tanphi_i = z / module / (1 - a * e * e * cos(phi_0) / (module * sqrt(1 - e * e * sin(phi_0) * sin(phi_0))))
	var phi_i = atan(tanphi_i)
	var delta: Double = fabs(phi_i - phi_0)
	while (delta > eps)
	{
		phi_0 = phi_i
		phi_i = atan(z / module / (1 - a * e * e * cos(phi_0) / (module * sqrt(1 - e * e * sin(phi_0) * sin(phi_0)))));
		delta = fabs(phi_i - phi_0)
	}
	let he = module / cos(phi_i) - a / sqrt(1 - e * e * sin(phi_i) * sin(phi_i))
	return Point(x: lon, y: phi_i, z: he)
}

internal func pointToWGS84(point: Point, zone: LambertZone) -> Point {
	var dest: Point
	if (.L93 == zone) {
		dest = lamberToGeographic(point, zone: zone, lon_merid: LON_MERID_IERS, e: E_WGS84, eps: EPS)
	} else {
		dest = lamberToGeographic(point, zone: zone, lon_merid: LON_MERID_PARIS, e: E_CLARK_IGN, eps: EPS)
		dest = geographicToCartesian(dest.x, lat: dest.y, he: dest.z, a: A_CLARK_IGN, e: E_CLARK_IGN)
		dest.x -= 168
		dest.y -= 60
		dest.z += 320
		dest = cartesianToGeographic(dest, meridian: LON_MERID_GREENWICH, a: A_WGS84, e: E_WGS84, eps: EPS)
	}
	return dest
}

// MARK: - WGS84ToGCJ-02

/// Constant for GCJ-02
var MarsLat: Double = 0
var MarsLon: Double = 0
let pi: Double = 3.14159265358979324
let a: Double = 6378245.0
let ee: Double = 0.00669342162296594323

internal func toMars() -> (Double, Double) {
	return (lat: MarsLat, lon: MarsLon)
}

internal func outOfChina(lat: Double, lon: Double) -> Bool {
	if (lon < 72.004 || lon > 137.8347 || lat < 0.8293 || lat > 55.8271) {
		return true
	}
	return false
}

internal func abs(v: Double) -> Double {
	return v < 0 ? -v : v
}

internal func tr_lat(x: Double, y: Double) -> Double {
	let t = abs(x)
	var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(t)
	ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
	ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0
	ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0
	return ret
}

internal func tr_lon(x: Double, y: Double) -> Double {
	let t = abs(x)
	var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(t)
	ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
	ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0
	ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0
	return ret
}

// MARK: - Main
extension CLLocation {
	public convenience init(x: Double, y: Double, inZone: LambertZone) {
		let org: Point = Point(x: x, y: y, z: 0)
		var dest: Point = pointToWGS84(org, zone: inZone)
		let f: Double = 180.0 / M_PI
		dest.x *= f
		dest.y *= f
		self.init(latitude: dest.y, longitude: dest.x)
	}

    public convenience init (lat: Double, lon: Double, country: Int) {
		if (outOfChina(lat, lon: lon) || country != 86) {
			MarsLat = lat
			MarsLon = lon
		} else {
			var dlat = tr_lat(lon - 105.0, y: lat - 35.0)
			var dlon = tr_lon(lon - 105.0, y: lat - 35.0)
			let radlat = lat / 180.0 * pi
			var magic = sin(radlat)
			magic = 1 - ee * magic * magic
			let sqrtMagic = sqrt(magic)
			dlat = (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
			dlon = (dlon * 180.0) / (a / sqrtMagic * cos(radlat) * pi)
			MarsLat = lat + dlat
			MarsLon = lon + dlon
		}
		self.init(latitude: MarsLat, longitude: MarsLon)
	}
}

extension CLLocationManager {
	/**
	 WGS转换成GCJ

	 - parameter wgsLoc: WGS CLLocationCoordinate2D
	 - returns: GCJ CLLocationCoordinate2D
	 */
	public func WGSToGCJ(wgsLoc: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
		var adjustLoc = wgsLoc
		if isLocationOutOfChina(wgsLoc) {
			var adjustLat = tr_lat(wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0)
			var adjustLon = tr_lon(wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0)
			let radLat = wgsLoc.latitude / 180.0 * pi
			var magic = sin(radLat)
			magic = 1 - ee * magic * magic
			let sqrtMagic = sqrt(magic)
			adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
			adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi)
			adjustLoc.latitude = wgsLoc.latitude + adjustLat
			adjustLoc.longitude = wgsLoc.longitude + adjustLon
		}
		return adjustLoc
	}

	/**
	 判断是不是属于国内范围

	 - parameter location: CLLocationCoordinate2D
	 - returns: Bool
	 */
	public func isLocationOutOfChina(location: CLLocationCoordinate2D) -> Bool {
		return outOfChina(location.longitude, lon: location.longitude)
	}
}
