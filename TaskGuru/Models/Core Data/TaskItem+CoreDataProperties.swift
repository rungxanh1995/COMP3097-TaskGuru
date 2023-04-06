//
//  TaskItem+CoreDataProperties.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-04-05.
//  Student ID: 101276573
//

import Foundation
import CoreData
import SwiftUI


extension TaskItem: Identifiable {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
		return NSFetchRequest<TaskItem>(entityName: "TaskItem")
	}
	
	// MARK: - Raw properties managed by Core Data
	@NSManaged private var cdDueDate: Date?
	@NSManaged private var cdID: UUID?
	@NSManaged private var cdLastUpdated: Date?
	@NSManaged private var cdName: String?
	@NSManaged private var cdNotes: String?
	@NSManaged private var cdPriority: String?
	@NSManaged private var cdStatus: String?
	@NSManaged private var cdType: String?
	
	// MARK: - Upwrapped public properties for safe access
	public var id: UUID {
		get { cdID ?? UUID() }
		set { cdID = newValue }
	}
	var name: String {
		get { cdName ?? "Untitled Task" }
		set {
			cdName = newValue
			cdLastUpdated = .now
		}
	}
	
	var dueDate: Date {
		get { cdDueDate ?? .endOfDay }
		set {
			cdDueDate = newValue
			cdLastUpdated = .now
		}
	}
	
	var numericDueDate: String {
		dueDate.formatted(date: .numeric, time: .shortened)
	}
	
	var shortDueDate: String {
		dueDate.formatted(.dateTime.day().month())
	}
	
	var relativeDueDate: String {
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .named
		return formatter.localizedString(for: dueDate, relativeTo: .now).capitalizingFirstLetter()
	}
	
	var lastUpdated: Date {
		get { cdLastUpdated ?? .now }
		set { cdLastUpdated = newValue }
	}
	
	var formattedLastUpdated: String {
		lastUpdated.formatted(date: .numeric, time: .shortened)
	}
	
	var type: TaskType {
		get { TaskType(rawValue: cdType ?? "Other") ?? .other }
		set {
			cdType = newValue.rawValue
			cdLastUpdated = .now
		}
	}
	
	var status: TaskStatus {
		get { TaskStatus(rawValue: cdStatus ?? "New") ?? .new }
		set {
			cdStatus = newValue.rawValue
			cdLastUpdated = .now
		}
	}
	
	var priority: TaskPriority {
		get { TaskPriority(rawValue: cdPriority ?? "None") ?? .none }
		set {
			cdPriority = newValue.rawValue
			cdLastUpdated = .now
		}
	}
	
	var isNotDone: Bool { status != .done }
	
	var notes: String {
		get { cdNotes ?? "" }
		set {
			cdNotes = newValue
			cdLastUpdated = .now
		}
	}
}

extension TaskItem {
	func colorForStatus() -> Color {
		switch status {
		case .new: return Color.gray
		case .inProgress: return Color.appYellow
		case .done: return Color.appClover
		}
	}
	
	/// Shows green when not approaching today's date, orange on today's date, and red when passed today's date
	func colorForDueDate() -> Color {
		if dueDate.isFromTomorrow {
			return Color.appClover
		} else if dueDate.isWithinToday {
			return Color.appYellow
		} else {
			return Color.appPink
		}
	}
	
	func colorForPriority() -> Color {
		switch priority {
		case .none: return Color.gray
		case .low: return Color.appClover
		case .medium: return Color.appYellow
		case .high: return Color.appPink
		}
	}
}
