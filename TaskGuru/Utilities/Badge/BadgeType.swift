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
		case .allPending: return "badgeType.allPending"
		case .overdue: return "badgeType.overdue"
		case .dueToday: return "badgeType.dueToday"
		case .upcoming: return "badgeType.upcoming"
		}
	}
}
