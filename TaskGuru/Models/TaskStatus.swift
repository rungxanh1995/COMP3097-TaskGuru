//
//  TaskStatus.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//

import Foundation

enum TaskStatus: String, Codable, CaseIterable {
	case new = "New"
	case inProgress = "In progress"
	case done = "Done"
}
