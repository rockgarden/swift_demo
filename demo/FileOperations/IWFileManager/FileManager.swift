//
//  FileManager.swift
//  IWFileManager
//
//  Created by Dylan McArthur on 8/18/16.
//  Copyright © 2016 Dylan McArthur. All rights reserved.
//

open class IWFileManager {
	
	// MARK: - Singleton
	
	open static let sharedManager: IWFileManager = {
		let fileManager = Foundation.FileManager()
		let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
		
		let instance = IWFileManager(fileManager: fileManager, documentsDirectory: documentsDirectory)
		
		return instance
	}()
	
	fileprivate init(fileManager: Foundation.FileManager, documentsDirectory: URL) {
		self.fileManager = fileManager
		self.documentsDirectoryURL = documentsDirectory
	}
	
	// MARK: - Properties
	
	public typealias Callback = (URL)->Void
	
	let fileManager: Foundation.FileManager
	
	let documentsDirectoryURL: URL
	
	let coordinationQueue: OperationQueue = {
		let coordinationQueue = OperationQueue()
		
		coordinationQueue.name = "com.dylanthejoel.IWFileManager.fileManager.coordinationQueue"
		
		return coordinationQueue
	}()
	
	// MARK: - Query Methods
	
	open func directoryURLByAppendingPath(_ path: String) -> URL {
		return documentsDirectoryURL.appendingPathComponent(path)
	}
	
	open func directoryModel(forDirectoryURL directoryURL: URL) -> [FileNode] {
		let files = try! fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [URLResourceKey(rawValue: kCFURLContentModificationDateKey as String as String), URLResourceKey(rawValue: kCFURLIsDirectoryKey as String as String)], options: [])
		
		var model = [FileNode]()
		
		for file in files {
			var p: AnyObject?
			try! (file as NSURL).getResourceValue(&p, forKey: URLResourceKey.isDirectoryKey)
			let isDirectory = p as! Bool
			
			let type: FileNodeType = (isDirectory) == true ? .folder : .file
			let node = FileNode(url: file, type: type)
			
			model.append(node)
		}
		
		return model
	}
	
	open func deepDirectoryModel(forDirectoryURL directoryURL: URL) -> [FileNode] {
		var nodes = [FileNode]()
		
		let enumerator = fileManager.enumerator(at: directoryURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles, errorHandler: nil)
		
		while let fileURL = enumerator?.nextObject() as? URL {
			
			var p: AnyObject?
			try! (fileURL as NSURL).getResourceValue(&p, forKey: URLResourceKey.isDirectoryKey)
			let isDirectory = p as! Bool
			
			var node: FileNode
			if isDirectory {
				node = FileNode(url: fileURL, type: .folder)
			} else {
				node = FileNode(url: fileURL, type: .file)
			}
			node.level = enumerator!.level - 1
			
			nodes.append(node)
		}
		
		return nodes
	}
	
	// MARK: - File System Methods
	
	open func createEmptyTextFile(named fileName: String, inDirectoryURL directoryURL: URL, completion: Callback?) {
		let data = ("").data(using: String.Encoding.utf8)!
		
		coordinationQueue.addOperation {
			let baseURL = directoryURL.appendingPathComponent((fileName as NSString).deletingPathExtension)
			
			var ext = (fileName as NSString).pathExtension
			if ext.isEmpty { ext = "md" }
			
			let target = self.availableFileForBaseURL(baseURL, ext: ext)
			
			let writeIntent = NSFileAccessIntent.writingIntent(with: target, options: [])
			
			NSFileCoordinator().coordinate(with: [writeIntent], queue: self.coordinationQueue, byAccessor: { (error) in
				if error != nil {
					return
				}
				
				self.fileManager.createFile(atPath: writeIntent.url.path, contents: data, attributes: nil)
				
				OperationQueue.main.addOperation({
					completion?(writeIntent.url)
				})
			})
		}
	}
	
	open func createDirectory(named directoryName: String, inDirectoryURL directoryURL: URL, completion: Callback?) {
		
		coordinationQueue.addOperation {
			let baseURL = directoryURL.appendingPathComponent(directoryName, isDirectory: true)
			
			let target = self.availableDirectoryForBaseURL(baseURL)
			
			let writeIntent = NSFileAccessIntent.writingIntent(with: target, options: [])
			
			NSFileCoordinator().coordinate(with: [writeIntent], queue: self.coordinationQueue, byAccessor: { (error) in
				if error != nil {
					return
				}
				
				do {
					try self.fileManager.createDirectory(at: writeIntent.url, withIntermediateDirectories: true, attributes: nil)
					
					OperationQueue.main.addOperation({
						completion?(writeIntent.url)
					})
				} catch {
					fatalError("Unexpected error creating folder: \(error)")
				}
			})
		}
		
	}
	
	open func createTemplateProject(named templateName: String, fromTemplateURL templateURL: URL, inDirectoryURL directoryURL: URL, completion: Callback?) {
		
		coordinationQueue.addOperation {
			let baseURL = directoryURL.appendingPathComponent(templateName, isDirectory: true)
			
			let target = self.availableDirectoryForBaseURL(baseURL)
			
			let readIntent = NSFileAccessIntent.readingIntent(with: templateURL, options: [])
			let writeIntent = NSFileAccessIntent.writingIntent(with: target, options: [])
			
			NSFileCoordinator().coordinate(with: [readIntent, writeIntent], queue: self.coordinationQueue, byAccessor: { (error) in
				if error != nil {
					return
				}
				
				do {
					try self.fileManager.copyItem(at: readIntent.url, to: writeIntent.url)
					
					OperationQueue.main.addOperation({
						completion?(writeIntent.url)
					})
				} catch {
					fatalError("Unexpected error creating template project: \(error)")
				}
			})
		}
	}
	
	open func move(itemAtURL sourceURL: URL, intoDirectoryURL directoryURL: URL, completion: Callback?) {
		
		coordinationQueue.addOperation {
			
			let isDirectory = self.checkPromisedURLIsDirectory(sourceURL)
			
			var target: URL
			
			if isDirectory {
				let baseURL = directoryURL.appendingPathComponent(sourceURL.lastPathComponent)
				
				target = self.availableDirectoryForBaseURL(baseURL)
			} else {
				let baseURL = directoryURL.appendingPathComponent((sourceURL.lastPathComponent as NSString).deletingPathExtension)
				
				let ext = sourceURL.pathExtension
				
				target = self.availableFileForBaseURL(baseURL, ext: ext)
			}
			
			let readIntent = NSFileAccessIntent.readingIntent(with: sourceURL, options: [])
			let writeIntent = NSFileAccessIntent.writingIntent(with: target, options: [])
			
			NSFileCoordinator().coordinate(with: [readIntent, writeIntent], queue: self.coordinationQueue, byAccessor: { (error) in
				if error != nil {
					return
				}
				
				do {
					try self.fileManager.moveItem(at: readIntent.url, to: writeIntent.url)
					
					OperationQueue.main.addOperation({
						completion?(writeIntent.url)
					})
				} catch {
					fatalError("Unexpected error moving: \(error)")
				}
			})
		}
		
	}
	
	open func rename(itemAtURL sourceURL: URL, usingName name: String, completion: Callback?) {
		
		coordinationQueue.addOperation {
			
			let isDirectory = self.checkPromisedURLIsDirectory(sourceURL)
			
			var target: URL
			
			if isDirectory {
				let baseURL = sourceURL.deletingLastPathComponent().appendingPathComponent(name)
				
				target = self.availableDirectoryForBaseURL(baseURL)
			} else {
				let baseURL = sourceURL.deletingLastPathComponent().appendingPathComponent((name as NSString).deletingPathExtension)
				
				var ext = (name as NSString).pathExtension
				if ext.isEmpty {
					let sourceExt = sourceURL.pathExtension
					if sourceExt.isEmpty != true { ext = sourceExt }
				}
				
				target = self.availableFileForBaseURL(baseURL, ext: ext)
			}
			
			let readIntent = NSFileAccessIntent.readingIntent(with: sourceURL, options: [])
			let writeIntent = NSFileAccessIntent.writingIntent(with: target, options: [])
			
			NSFileCoordinator().coordinate(with: [readIntent, writeIntent], queue: self.coordinationQueue, byAccessor: { (error) in
				if error != nil {
					return
				}
				
				do {
					try self.fileManager.moveItem(at: readIntent.url, to: writeIntent.url)
					
					OperationQueue.main.addOperation({
						completion?(writeIntent.url)
					})
				} catch {
					fatalError("Unexpected error renaming: \(error)")
				}
			})
		}
		
	}
	
	open func delete(itemAtURL url: URL, completion: @escaping ()->Void) {
		
		coordinationQueue.addOperation {
			let writeIntent = NSFileAccessIntent.writingIntent(with: url, options: .forDeleting)
			
			NSFileCoordinator().coordinate(with: [writeIntent], queue: self.coordinationQueue, byAccessor: { (error) in
				if error != nil {
					return
				}
				
				do {
					try self.fileManager.removeItem(at: writeIntent.url)
					
					OperationQueue.main.addOperation({
						completion()
					})
				} catch {
					fatalError("unexpected error deleting item: \(error)")
				}
			})
		}
		
	}
	
	// MARK: - Private Helper Functions
	
	func availableFileForBaseURL(_ baseURL: URL, ext: String) -> URL {
		var target = baseURL.appendingPathExtension(ext)
		
		var nameSuffix = 1
		
		while (target as NSURL).checkPromisedItemIsReachableAndReturnError(nil) {
			target = URL(fileURLWithPath: baseURL.path + "-\(nameSuffix).\(ext)")
			
			nameSuffix += 1
		}
		
		return target
	}
	
	func availableDirectoryForBaseURL(_ baseURL: URL) -> URL {
		var target = baseURL
		
		var nameSuffix = 1
		
		while (target as NSURL).checkPromisedItemIsReachableAndReturnError(nil) {
			target = URL(fileURLWithPath: baseURL.path + "-\(nameSuffix)", isDirectory: true)
			
			nameSuffix += 1
		}
		
		return target
	}
	
	func checkPromisedURLIsDirectory(_ url: URL) -> Bool {
		var p: AnyObject?
		
		if (url as NSURL).checkPromisedItemIsReachableAndReturnError(nil) {
			try! (url as NSURL).getResourceValue(&p, forKey: URLResourceKey.isDirectoryKey)
			return p as! Bool
		}
		
		return false
	}
	
}
