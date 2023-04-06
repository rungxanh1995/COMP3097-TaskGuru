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
		case .berry: return .appPink
		case .orange: return .appOrange
		case .yellow: return .appYellow
		case .green: return .appGreen
		case .clover: return .appClover
		case .teal: return .appTeal
		case .blue: return .appBlue
		case .indigo: return .appIndigo
		case .purple: return .appPurple
		}
	}

	// MARK: - Using app specific color assets
	/// The custom pink color specific to TaskGuru
	static var appPink: Color {	.init("Berry") }
	/// The custom orange color specific to TaskGuru
	static var appOrange: Color { .init("Orange") }
	/// The custom yellow color specific to TaskGuru
	static var appYellow: Color { .init("Yellow") }
	/// The custom green color specific to TaskGuru
	static var appGreen: Color { .init("Green") }
	/// The custom clover color specific to TaskGuru
	static var appClover: Color { .init("Clover") }
	/// The custom teal color specific to TaskGuru
	static var appTeal: Color { .init("Teal") }
	/// The custom blue color specific to TaskGuru
	static var appBlue: Color { .init("Blue") }
	/// The custom indigo color specific to TaskGuru
	static var appIndigo: Color { .init("Indigo") }
	/// The custom indigo color specific to TaskGuru
	static var appPurple: Color { .init("Purple") }

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
