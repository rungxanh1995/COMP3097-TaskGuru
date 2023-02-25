//
//  Image.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-22.
//	Student ID: 101276573
//

import SwiftUI

extension Image {
	/// Frames image as a medium icon size for a row in App icon settings view.
	func asIconSize() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 44, height: 44)
			.clipShape(RoundedRectangle(cornerRadius: 10))
	}
	
	/// Frames image as a small icon size for a row in Settings view.
	func asSettingsIconSize() -> some View {
		self
			.resizable()
			.scaledToFit()
			
			.frame(width: 28, height: 28)
			
			.clipShape(RoundedRectangle(cornerRadius: 10*(28/44)))
	}
}
