//
//  AccentPalette.swift
//  TaskGuru
//
//  Created by Joe Pham on 18/3/23.
//  Student ID: 101276573
//

import SwiftUI

/// A single source of true for a dynamic color palette of the app.
public struct AccentColorPalette {
	private var colorScheme: ColorScheme
	@AppStorage(UserDefaultsKey.accentColor) private var accentColor: Int = AccentColorType.clover.rawValue

	public init(colorScheme: ColorScheme = .light) {
		self.colorScheme = colorScheme
	}

	/// These colors are inspired by Ivory app from Tapbots Inc, and is legible in both light and dark mode.
	public var selectedAccentColor: Color? {
		guard let accentColor = AccentColorType(rawValue: self.accentColor) else { return nil }
		switch accentColor {
		case .berry: return Color(hex: colorScheme == .light ? 0xE51817 : 0xE54545)
		case .orange: return Color(hex: colorScheme == .light ? 0xE47101 : 0xE4892E)
		case .yellow: return Color(hex: colorScheme == .light ? 0xF0B302 : 0xE5BC45)
		case .green: return Color(hex: colorScheme == .light ? 0x70BE00 : 0xA3E547)
		case .clover: return Color(hex: colorScheme == .light ? 0x02C564 : 0x46E495)
		case .teal: return Color(hex: colorScheme == .light ? 0x00BBCC : 0x44D7E6)
		case .blue: return Color(hex: colorScheme == .light ? 0x0080FE : 0x4CA5FF)
		case .indigo: return Color(hex: colorScheme == .light ? 0x5500FE : 0x9966FF)
		case .purple: return Color(hex: colorScheme == .light ? 0xA901FF : 0xC34CFE)
		}
	}
}
