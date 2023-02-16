//
//  TaskItem.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//	Student ID: 101276573
//

import SwiftUI

struct TaskItem: Identifiable, Hashable {
	var id: UUID = UUID()
	
	var name: String {
		didSet { lastUpdated = .now }
	}
	
	var dueDate: Date  {
		didSet { lastUpdated = .now }
	}
	
	var numericDueDate: String {
		dueDate.formatted(date: .numeric, time: .omitted)
	}
	
	var shortDueDate: String {
		dueDate.formatted(date: .abbreviated, time: .omitted)
	}
	
	var lastUpdated: Date
	
	var formattedLastUpdated: String {
		lastUpdated.formatted(date: .numeric, time: .shortened)
	}
	
	var type: TaskType  {
		didSet { lastUpdated = .now }
	}
	
	var status: TaskStatus  {
		didSet { lastUpdated = .now }
	}
	
	var isNotDone: Bool { status != .done }
	
	var notes: String  {
		didSet { lastUpdated = .now }
	}
}

extension TaskItem {
	static let mockData: [TaskItem] = [
		TaskItem(name: "Register schedule 🎓", dueDate: Date(timeIntervalSinceNow: -60*60*24),
				 lastUpdated: .now, type: .school, status: .done, notes: ""),
		TaskItem(name: "Check tax account 💸", dueDate: Date(timeIntervalSinceNow: -60*60*2),
				 lastUpdated: .now, type: .other, status: .inProgress, notes: ""),
		TaskItem(name: "Buy vacation ticket 🎟️", dueDate: Date(timeIntervalSinceNow: 60*60*24*135),
				 lastUpdated: .now, type: .personal, status: .inProgress, notes: "Look for affordable options"),
		TaskItem(name: "Design document 🎨", dueDate: Date(timeIntervalSinceNow: 60*60*24*15),
				 lastUpdated: .now, type: .school, status: .done,
				 notes: "A prototype of the GUI for app with mock data/hardcoded info done in Xcode"),
		TaskItem(name: "Early prototype 📱", dueDate: Date(timeIntervalSinceNow: 60*60*24*45), lastUpdated: .now,
				 type: .school, status: .new,
				 notes: "Implementation of one of the screens described in the proposal document."),
		TaskItem(name: "Final implementation", dueDate: Date(timeIntervalSinceNow: 60*60*24*90), lastUpdated: .now,
				 type: .school, status: .new, notes: "")
	]
}

extension TaskItem {
	func colorForStatus() -> Color {
		switch status {
			case .new: return Color.gray
			case .inProgress: return Color.orange
			case .done: return Color.mint
		}
	}
	
	/// Shows green when not approaching today's date, orange on today's date, and red when passed today's date
	func colorForDueDate() -> Color {
		if dueDate.isInTheFuture {
			return Color.mint
		} else if dueDate.isWithinToday {
			return Color.orange
		} else {
			return Color.red
		}
	}
}
