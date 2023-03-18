//
//  DynamicHighlightBackground.swift
//  TaskGuru
//
//  Created by Joe Pham on 18/3/23.
//  Student ID: 101276573
//

import SwiftUI

/// A dynamic view that changes the color to the accent color selected by the user in settings.
///
/// The view ensures that text is legible in both light and dark mode
/// by using a white background with a light accent color in light mode,
/// and a gray background with a light accent color in dark mode.
struct DynamicHighlightBackground: View {
	@Environment(\.colorScheme) private var systemScheme
	@AppStorage(UserDefaultsKey.accentColor) private var accentColor: Int = AccentColorType.clover.rawValue

	var body: some View {
		let accentPalette = AccentColorPalette(colorScheme: systemScheme)
		switch systemScheme {
		case .light:
			ZStack {
				Color.white
				accentPalette.selectedAccentColor.opacity(0.075)
			}
		case .dark:
			ZStack {
				Color.gray.opacity(0.25)
				accentPalette.selectedAccentColor.opacity(0.1)
			}
		@unknown default:
			ZStack {
				Color.white
				accentPalette.selectedAccentColor.opacity(0.075)
			}
		}
	}
}
