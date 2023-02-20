//
//  BadgeType.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-19.
//	Student ID: 101276573
//

import Foundation

enum BadgeType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case allPending
	case overdue
	case dueToday
	case upcoming
}

extension BadgeType {
	var title: String {
		switch self {
		case .allPending: return "All Pending"
		case .overdue: return "Overdue"
		case .dueToday: return "Due Today"
		case .upcoming: return "Upcoming"
		}
	}
}
