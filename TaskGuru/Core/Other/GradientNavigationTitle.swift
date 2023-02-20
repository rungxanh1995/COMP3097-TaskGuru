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
			.foregroundStyle(Color.defaultAccentColor.gradient)
	}
}

struct GradientNavigationTitle_Previews: PreviewProvider {
	static var previews: some View {
		GradientNavigationTitle(text: "All Tasks")
	}
}
