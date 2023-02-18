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
		case .red: return .red
		case .orange: return .orange
		case .yellow: return .yellow
		case .green: return .green
		case .mint: return .mint
		}
	}
}
