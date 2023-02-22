//
//  Image.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-22.
//	Student ID: 101276573
//

import SwiftUI

extension Image {
	func asIconSize() -> some View {
		self
			.resizable()
			.scaledToFit()
			.frame(width: 44, height: 44)
			.clipShape(RoundedRectangle(cornerRadius: 10))
	}
}
