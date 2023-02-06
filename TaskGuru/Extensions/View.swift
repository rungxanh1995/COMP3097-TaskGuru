//
//  View.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-06.
//

import SwiftUI

extension View {
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
