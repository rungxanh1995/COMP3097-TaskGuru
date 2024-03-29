//
//  TaskStatus.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//	Student ID: 101276573
//

import Foundation

enum TaskStatus: String, Codable, CaseIterable {
	case new = "taskItem.status.new"
	case inProgress = "taskItem.status.inProgress"
	case done = "taskItem.status.done"
}

extension TaskStatus {
	var accessibilityString: String {
		switch self {
		case .new: return "New"
		case .inProgress: return "In progress"
		case .done: return "Done"
		}
	}
}
