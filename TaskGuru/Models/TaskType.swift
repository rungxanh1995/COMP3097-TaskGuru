//
//  TaskType.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//	Student ID: 101276573
//

import Foundation

enum TaskType: String, Codable, CaseIterable {
	case personal = "taskItem.type.personal"
	case work = "taskItem.type.work"
	case school = "taskItem.type.school"
	case coding = "taskItem.type.coding"
	case other = "taskItem.type.other"
}
