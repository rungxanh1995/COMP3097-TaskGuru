//
//  AccentColorModifier.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-18.
//	Student ID: 101276573
//

import SwiftUI

struct AccentColorModifier: ViewModifier {
	@Environment(\.colorScheme) private var systemScheme

	// This property ensures that this view modifier is updated whenever the accent color is changed.
	// The publisher associated with this property triggers the view modifier to update accordingly.
	// Therefore, please DO NOT remove this property.
	@AppStorage(UserDefaultsKey.accentColor)
	private var accentColor: Int = AccentColorType.clover.rawValue

	func body(content: Content) -> some View {
		let selectedAccentColor = AccentColorType(rawValue: self.accentColor)
		content
			.tint(selectedAccentColor?.associatedColor)
	}
}
