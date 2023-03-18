//
//  AccentColor.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-18.
//	Student ID: 101276573
//

import SwiftUI

enum AccentColorType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case berry, orange, yellow, green, clover, teal, blue, indigo, purple
}

extension AccentColorType {
	var title: String {
		switch self {
		case .berry: return "accentColor.berry"
		case .orange: return "accentColor.orange"
		case .yellow: return "accentColor.yellow"
		case .green: return "accentColor.green"
		case .clover: return "accentColor.clover"
		case .teal: return "accentColor.teal"
		case .blue: return "accentColor.blue"
		case .indigo: return "accentColor.indigo"
		case .purple: return "accentColor.purple"
		}
	}

	var associatedColor: Color {
		switch self {
		case .berry: return Color(hex: 0xE51817)
		case .orange: return Color(hex: 0xE47101)
		case .yellow: return Color(hex: 0xF0B302)
		case .green: return Color(hex: 0x70BE00)
		case .clover: return Color(hex: 0x02C564)
		case .teal: return Color(hex: 0x00BBCC)
		case .blue: return Color(hex: 0x0080FE)
		case .indigo: return Color(hex: 0x5500FE)
		case .purple: return Color(hex: 0xA901FF)
		}
	}
}
