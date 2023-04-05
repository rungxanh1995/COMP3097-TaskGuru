//
//  String.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-04-05.
//  Student ID: 101276573
//

import Foundation

extension String {
	func capitalizingFirstLetter() -> String {
		return prefix(1).capitalized + dropFirst()
	}
	
	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}
}
