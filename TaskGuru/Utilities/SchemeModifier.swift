//
//  SchemeModifier.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-15.
//	Student ID: 101276573
//

import SwiftUI

struct SchemeModifier: ViewModifier {
	@AppStorage(UserDefaultsKey.systemTheme)
	private var systemTheme: Int = SchemeType.allCases.first!.rawValue
	
	private var selectedScheme: ColorScheme? {
		guard let theme = SchemeType(rawValue: self.systemTheme) else { return nil }
		switch theme {
		case .system: return nil
		case .light: return .light
		case .dark: return .dark
		}
	}
	
	func body(content: Content) -> some View {
		content
			.preferredColorScheme(selectedScheme)
	}
}
