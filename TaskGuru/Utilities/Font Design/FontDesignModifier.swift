//
//  FontDesignModifier.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-18.
//	Student ID: 101276573
//

import SwiftUI

struct FontDesignModifier: ViewModifier {
	@AppStorage(UserDefaultsKey.fontDesign)
	private var fontDesign: Int = FontDesignType.allCases.first!.rawValue

	private var selectedFontDesign: Font.Design? {
		guard let design = FontDesignType(rawValue: self.fontDesign) else { return nil }
		switch design {
		case .system: return .default
		case .rounded: return .rounded
		case .monospaced: return .monospaced
		case .serif: return .serif
		}
	}

	func body(content: Content) -> some View {
		if #available(iOS 16.1, *) {
			content.fontDesign(selectedFontDesign)
		} else {
			content
		}
	}
}
