//
//  GradientNavigationTitle.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-02-17.
//  Student ID: 101307949
//

import SwiftUI

struct GradientNavigationTitle: View {
	@Preference(\.accentColor) private var accentColor
	let text: LocalizedStringKey

	var body: some View {
		Text(text)
			.font(.system(.title, design: .rounded))
			.fontWeight(.bold)
			.foregroundStyle(selectedAccentColor.gradient)
	}
}

extension GradientNavigationTitle {
	/// Converts user selected accent color from Settings to Apple inbuilt `Color`.
	private var selectedAccentColor: Color {
		guard let accent = AccentColorType(rawValue: accentColor) else {
			return Color.accentColor
		}
		switch accent {
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

struct GradientNavigationTitle_Previews: PreviewProvider {
	static var previews: some View {
		GradientNavigationTitle(text: "All Tasks")
	}
}
