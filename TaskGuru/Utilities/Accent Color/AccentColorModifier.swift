//
//  AccentColorModifier.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-18.
//	Student ID: 101276573
//

import SwiftUI

struct AccentColorModifier: ViewModifier {
	@AppStorage(UserDefaultsKey.accentColor)
	private var accentColor: Int = AccentColorType.allCases.first!.rawValue
	
	private var selectedAccentColor: Color? {
		guard let accentColor = AccentColorType(rawValue: self.accentColor) else { return nil }
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
	
	func body(content: Content) -> some View {
		content
			.tint(selectedAccentColor)
	}
}
