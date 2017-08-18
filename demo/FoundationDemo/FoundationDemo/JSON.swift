//
//  JSON.swift
//  FoundationDemo
//
//  Created by wangkan on 2017/8/18.
//  Copyright © 2017年 rockgarden. All rights reserved.
//

/**
 {
	"name": "Caffè Macs",
	"coordinates": {
 "lat": 37.330576,
 "lng": -122.029739
	},
	"meals": ["breakfast", "lunch", "dinner"]
 }
 
 {
	"query": "sandwich",
	"results_count": 12,
	"page": 1,
	"results": [
 {
 "name": "Caffè Macs",
 "coordinates": {
 "lat": 37.330576,
 "lng": -122.029739
 },
 "meals": ["breakfast", "lunch", "dinner"]
 },
 ...
	]
 }
 
 */
import Foundation


struct Restaurant {
    enum Meal: String {
        case breakfast, lunch, dinner
    }
    
    let name: String
    let coordinates: (latitude: Double, longitude: Double)
    let meals: Set<Meal>
}


extension Restaurant {
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let coordinatesJSON = json["coordinates"] as? [String: Double],
            let latitude = coordinatesJSON["lat"],
            let longitude = coordinatesJSON["lng"],
            let mealsJSON = json["meals"] as? [String]
            else {
                return nil
        }
        
        var meals: Set<Meal> = []
        for string in mealsJSON {
            guard let meal = Meal(rawValue: string) else {
                return nil
            }
            
            meals.insert(meal)
        }
        
        self.name = name
        self.coordinates = (latitude, longitude)
        self.meals = meals
    }
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Restaurant {
    init(_ json: [String: Any]) throws {
        // Extract name
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        // Extract and validate coordinates
        guard let coordinatesJSON = json["coordinates"] as? [String: Double],
            let latitude = coordinatesJSON["lat"],
            let longitude = coordinatesJSON["lng"]
            else {
                throw SerializationError.missing("coordinates")
        }
        
        let coordinates = (latitude, longitude)
        guard case (-90...90, -180...180) = coordinates else {
            throw SerializationError.invalid("coordinates", coordinates)
        }
        
        // Extract and validate meals
        guard let mealsJSON = json["meals"] as? [String] else {
            throw SerializationError.missing("meals")
        }
        
        var meals: Set<Meal> = []
        for string in mealsJSON {
            guard let meal = Meal(rawValue: string) else {
                throw SerializationError.invalid("meals", string)
            }
            
            meals.insert(meal)
        }
        
        // Initialize properties
        self.name = name
        self.coordinates = coordinates
        self.meals = meals
    }
}


extension Restaurant {

//    let urlComponents: URLComponents // base URL components of the web service
//    let session: URLSession // shared session for interacting with the web service
    
//    static func restaurants(matching query: String, completion: @escaping ([Restaurant]) -> Void) {
//        var searchURLComponents = urlComponents!
//        searchURLComponents.path = "/search"
//        searchURLComponents.queryItems = [URLQueryItem(name: "q", value: query)]
//        let searchURL = searchURLComponents.url!
//        
//        session.dataTask(url: searchURL, completion: { (_, _, data, _)
//            var restaurants: [Restaurant] = []
//            
//            if let data = data,
//                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                for case let result in json["results"] {
//                    if let restaurant = Restaurant(json: result) {
//                        restaurants.append(restaurant)
//                    }
//                }
//            }
//            
//            completion(restaurants)
//        }).resume()
//    }
}
