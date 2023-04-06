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
}
