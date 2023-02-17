//
//  View.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-06.
//	Student ID: 101276573
//

import SwiftUI

extension View {
	/// Configure the color theme of this application.
	func setUpColorTheme() -> some View {
		modifier(SchemeModifier())
	}
	
	func makeCheerfulDecorativeImage() -> some View {
		HStack {
			Spacer()
			Image("happy-sun")
				.resizable()
				.scaledToFit()
				.frame(width: 200, height: 200)
			Spacer()
		}
	}
}
