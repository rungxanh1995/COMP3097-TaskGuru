//
//  TaskType.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//	Student ID: 101276573
//

import Foundation

enum TaskType: String, Codable, CaseIterable {
	case personal = "Personal"
	case work = "Work"
	case school = "School"
	case coding = "Coding"
	case other = "Other"
}
