//
//  FindPokemonOperation.swift
//  PokeScan
//
//  Created by JarlRyan on 16/7/29.
//  Copyright © 2016年 JarlRyan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FindPokemonOperation: ConcurrentOperation {
	let URLString: String
	let findPokemonCompletionHandler: (responseObjects: [PokemonEntity], error: NSError?) -> ()
	weak var request: Alamofire.Request?

	init(URLString: String, findPokemonCompletionHandler: (responseObjects: [PokemonEntity], error: NSError?) -> ()) {
		self.URLString = URLString
		self.findPokemonCompletionHandler = findPokemonCompletionHandler
		super.init()
	}

	override func main() {
		request = Alamofire.request(.GET, URLString)
			.responseJSON {
				response in
				if self.cancelled {
					print("Alamofire.download cancelled while downlading. Not proceed.")
				} else {
					if response.result.isSuccess {
						let jsons: JSON = JSON(response.result.value!)
						let pokemons = jsons["pokemons"].arrayValue

						self.findPokemonCompletionHandler(responseObjects: self.handlerJson(pokemons), error: response.result.error)
						debugPrint("\(self.URLString):count\(pokemons.count)")

					} else {
						debugPrint(response.result.error)
					}
				}
				self.completeOperation()
		}
	}

	func handlerJson(jsons: [JSON]) -> [PokemonEntity] {
		var returnPokes: [PokemonEntity] = [PokemonEntity]()
		let specialPokemon = UserDefault.instance.getPokemonFilterArr()
		for json in jsons {
			for pokeid in specialPokemon {
				if json["pokemon_id"].stringValue == pokeid {
					let name = PokemonUtil.getName(pokeid)
					let enName = json["pokemon_name"].stringValue
					let longitude = json["longitude"].stringValue
					let latitude = json["latitude"].stringValue
					let date: NSTimeInterval = Double(json["expires"].intValue)

					let finalName = "\(name):\(enName)"

					let pokeObj: PokemonEntity = PokemonEntity(latitude: latitude, longitude: longitude, pokemonName: finalName, expires: Int(date), pokemonId: json["pokemon_id"].intValue)
					returnPokes.append(pokeObj)
				}
			}
		}
		return returnPokes
	}

	override func cancel() {
		request?.cancel()
		super.cancel()
	}
}