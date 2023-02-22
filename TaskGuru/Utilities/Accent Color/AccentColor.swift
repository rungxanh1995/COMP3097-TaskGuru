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
	case blue, teal, indigo, pink, berry, red, orange, yellow, green, mint, clover
}

extension AccentColorType {
	var title: String {
		switch self {
		case .blue: return "Blue"
		case .teal: return "Teal"
		case .indigo: return "Indigo"
		case .pink: return "Pink"
		case .berry: return "Berry"
		case .red: return "Red"
		case .orange: return "Orange"
		case .yellow: return "Yellow"
		case .green: return "Green"
		case .mint: return "Mint"
		case .clover: return "Clover"
		}
	}

	var associatedColor: Color {
		switch self {
		case .blue: return .blue
		case .teal: return .teal
		case .indigo: return .indigo
		case .pink: return .pink
		case .berry: return Color(hex: 0xC93C4B)
		case .red: return .red
		case .orange: return .orange
		case .yellow: return .yellow
		case .green: return .green
		case .mint: return .mint
		case .clover: return Color(hex: 0x4597A1)
		}
	}
}
