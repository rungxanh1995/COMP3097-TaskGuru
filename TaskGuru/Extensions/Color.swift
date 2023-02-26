//
//  Color.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-18.
//	Student ID: 101276573
//

import SwiftUI

extension Color {
	@Preference(\.accentColor) private static var userAccentColor

	/// Returns a color to be used as default for the app, otherwise uses the defined accent color in Assets catalog.
	static var defaultAccentColor: Color {
		guard let accentColor = AccentColorType(rawValue: userAccentColor) else {
			return Color("AccentColor")
		}

		switch accentColor {
		case .blue: return .blue
		case .teal: return .teal
		case .indigo: return .indigo
		case .pink: return .pink
		case .berry: return Color(hex: 0xEF0808)
		case .red: return .red
		case .orange: return .orange
		case .yellow: return .yellow
		case .green: return .green
		case .mint: return .mint
		case .clover: return Color(hex: 0x4597A1)
		}
	}

	/// Allows initializing color from hex code with format "0xABCDEF"
	init(hex: UInt, alpha: Double = 1) {
		self.init(
			.sRGB,
			red: Double((hex >> 16) & 0xff) / 255,
			green: Double((hex >> 08) & 0xff) / 255,
			blue: Double((hex >> 00) & 0xff) / 255,
			opacity: alpha
		)
	}
}
