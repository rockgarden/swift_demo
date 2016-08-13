//
//  AlphaOperation.swift
//  PokeScan
//
//  Created by JarlRyan on 16/7/29.
//  Copyright © 2016年 JarlRyan. All rights reserved.
//

import Foundation
import SwiftyJSON
class AlphaOperation: NSOperation {
	var queue: NSOperationQueue?
	var urlList: [String] = [String]()
	let completionHandler: (responseObjects: [PokemonEntity]) -> ()
	let allCompletionHandler: () -> ()
	let progress: (progress: Float) -> ()
	var resultPokes: [PokemonEntity] = [PokemonEntity]()

	init(urlList: [String], completionHandler: (responseObjects: [PokemonEntity]) -> (), allCompletionHandler: () -> (), progress: (progress: Float) -> ()) {
		self.urlList = urlList
		self.completionHandler = completionHandler
		self.allCompletionHandler = allCompletionHandler
		self.progress = progress
		super.init()
	}
	override func main() {
		self.queue = NSOperationQueue()
		self.queue?.maxConcurrentOperationCount = 3
		var i: Float = 0
		for url in urlList {
			let bateOperation = FindPokemonOperation(URLString: url, findPokemonCompletionHandler: {
				(pokes: [PokemonEntity], err: NSError?) in
				for poke in pokes {
					if !self.resultPokes.contains(poke) {
						self.resultPokes.append(poke)
					}
				}
				if pokes.count > 0 {
					self.completionHandler(responseObjects: self.resultPokes)
				}
				let p: Float = i / Float(self.urlList.count)
				i += 1
				self.progress(progress: p)
			})
			queue?.addOperation(bateOperation)
		}
		queue?.waitUntilAllOperationsAreFinished()
		allCompletionHandler()
	}

	override func cancel() {
		super.cancel()

	}
}