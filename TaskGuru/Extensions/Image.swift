//
//  Image.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-22.
//	Student ID: 101276573
//

import SwiftUI

extension Image {
	/// Frames image as a large icon size, could be used in Onboarding screen.
	func asLargeIconSize() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 84, height: 84)
			.clipShape(RoundedRectangle(cornerRadius: 22))
	}

	/// Frames image as a medium icon for a row in App icon settings view.
	func asIcon() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 40, height: 40)
			.clipShape(RoundedRectangle(cornerRadius: 9))
	}

	/// Frames image as a medium icon size for a row in App icon settings view.
	func asIconSize() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 40, height: 40)
	}

	/// Frames image as a small icon for a row in Settings view.
	func asSettingsIcon() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 28, height: 28)
			.clipShape(RoundedRectangle(cornerRadius: 9*(28/40)))
	}
}
