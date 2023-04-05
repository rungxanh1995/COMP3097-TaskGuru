//
//  PreviewProvider.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-03-17.
//  Student ID: 101307949
//

import SwiftUI

extension PreviewProvider {
	static var dev: DeveloperPreview { .instance }
}

final class DeveloperPreview {
	static let instance: DeveloperPreview = .init()
	private init() {}

	let homeVM: HomeViewModel = .init()
	let task: TaskItem = makeSampleTask()
	
	fileprivate static func makeSampleTask() -> TaskItem {
		// swiftlint:disable line_length
		let task: TaskItem = TaskItem(context: StorageProviderImpl.standard.context)
		task.id = UUID()
		task.name = "Group project presentation"
		task.type = .school
		task.status = .inProgress
		task.dueDate = .now
		task.priority = .medium
		task.notes = "An advanced ToDo application with several types of tasks and ability to create new tasks and new kinds of tasks."
		
		return task
	}
}
