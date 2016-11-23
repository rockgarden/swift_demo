//
//  File Models.swift
//  IWFileManager
//
//  Created by Dylan McArthur on 8/19/16.
//  Copyright © 2016 Dylan McArthur. All rights reserved.
//

public enum FileNodeType {
	case file, folder
}

open class FileNode: CustomStringConvertible {
	
	open var name = ""
	
	open var type: FileNodeType = .file
	
	open var level = 0
	
	open var url: URL
	
	public init(url: URL, type: FileNodeType) {
		self.url = url
		self.name = url.lastPathComponent
		self.type = type
	}
	
	open var description: String {
		var ticks = ""
		for _ in 0..<level {
			ticks += "- "
		}
		
		return ticks + name + " (\(type)) "
	}
	
}
