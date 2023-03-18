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
		case .berry: return Color(hex: 0xE54545)
		case .orange: return Color(hex: 0xE47101)
		case .yellow: return Color(hex: 0xF0B302)
		case .green: return Color(hex: 0xA3E547)
		case .clover: return Color(hex: 0x02C564)
		case .teal: return Color(hex: 0x00BBCC)
		case .blue: return Color(hex: 0x0080FE)
		case .indigo: return Color(hex: 0x5500FE)
		case .purple: return Color(hex: 0xA901FF)
		}
	}

	/// The custom pink color specific to TaskGuru
	static var appPink: Color {	Color(hex: 0xE54545) }
	/// The custom orange color specific to TaskGuru
	static var appOrange: Color { Color(hex: 0xE47101) }
	/// The custom yellow color specific to TaskGuru
	static var appYellow: Color { Color(hex: 0xF0B302) }
	/// The custom green color specific to TaskGuru
	static var appGreen: Color { Color(hex: 0xA3E547) }
	/// The custom teal color specific to TaskGuru
	static var appTeal: Color { Color(hex: 0x02C564) }
	/// The custom blue color specific to TaskGuru
	static var appBlue: Color { Color(hex: 0x0080FE) }
	/// The custom indigo color specific to TaskGuru
	static var appIndigo: Color { Color(hex: 0x5500FE) }
	/// The custom indigo color specific to TaskGuru
	static var appPurple: Color { Color(hex: 0xA901FF) }

	/// Allows initializing color from hex code with format "0xABCDEF"
	init(hex: UInt, alpha: Double = 1) {
		self.init(
			.displayP3,
			red: Double((hex >> 16) & 0xff) / 255,
			green: Double((hex >> 08) & 0xff) / 255,
			blue: Double((hex >> 00) & 0xff) / 255,
			opacity: alpha
		)
	}
}
