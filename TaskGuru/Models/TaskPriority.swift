//
//  TaskPriority.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-04-05.
//  Student ID: 101276573
//

import Foundation

enum TaskPriority: String, Codable, CaseIterable {
	case none = "taskItem.priority.none"
	case low = "taskItem.priority.low"
	case medium = "taskItem.priority.medium"
	case high = "taskItem.priority.high"
}

extension TaskPriority {
	var visualized: String {
		switch self {
		case .none: return ""
		case .low: return "!"
		case .medium: return "!!"
		case .high: return "!!!"
		}
	}

	var accessibilityString: String {
		switch self {
		case .none: return "No"
		case .low: return "Low"
		case .medium: return "Medium"
		case .high: return "High"
		}
	}
}
