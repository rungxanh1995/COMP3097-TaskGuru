//
//  HomeViewModel.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-03-17.
//  Student ID: 101307949
//

import Foundation

final class HomeViewModel: ObservableObject {
	@Published private(set) var allTasks: [TaskItem] = .init()
	
	@Published var searchText = ""
	
	var searchResults: [TaskItem] {
		if searchText.isEmpty {
			return allTasks
		} else {
			return allTasks.filter { task in
				task.name.localizedCaseInsensitiveContains(searchText) ||
				task.type.rawValue.lowercased().localizedCaseInsensitiveContains(searchText) ||
				task.status.rawValue.localizedCaseInsensitiveContains(searchText) ||
				task.notes.lowercased().localizedCaseInsensitiveContains(searchText) ||
				task.dueDate.formatted().localizedCaseInsensitiveContains(searchText)
			}
		}
	}
	
	var pendingTasks: [TaskItem] { allTasks.filter { $0.isNotDone } }
	
	@Published var isShowingAddTaskView: Bool = false
	@Published var isConfirmingClearDoneTasks: Bool = false
	
	var noPendingTasksLeft: Bool { searchResults.filter { $0.isNotDone }.isEmpty }
	
	// MARK: - CRUD Operations
	
	// ADD
	
	func addTask(name: inout String, type: TaskType, dueDate: Date, status: TaskStatus, notes: String) {
		let newItem = TaskItem(name: name, dueDate: dueDate, lastUpdated: .now,
                               type: type, status: status, notes: notes)
		allTasks.append(newItem)
	}
	
	// UPDATE
	func updateTasks(with item: TaskItem) {
		guard let index = getIndex(of: item) else { return }
		allTasks[index] = item
	}
	
	fileprivate func getIndex(of item: TaskItem) -> Int? {
		return allTasks.firstIndex { $0.id == item.id }
	}
	
	func delete(_ task: TaskItem) {
		guard let index = getIndex(of: task) else { return }
		allTasks.remove(at: index)
		haptic(.success)
	}
	
	func markAsDone(_ task: TaskItem) {
		// TODO: mark task as done in final implementation stage
		// Unable to do now, as `TaskItem` is a struct, and a mutating func
		// couldn't modify its `status` property either.
		haptic(.success)
	}
	
	
	func markAsInProgress(_ task: TaskItem) {
		// TODO: mark task as in progress in final implementation stage
		// Unable to do now, as `TaskItem` is a struct, and a mutating func
		// couldn't modify its `status` property either.
		haptic(.success)
	}
	
	func markAsNew(_ task: TaskItem) {
		// TODO: mark task as new in final implementation stage
		// Unable to do now, as `TaskItem` is a struct, and a mutating func
		// couldn't modify its `status` property either.
		haptic(.success)
	}
	
	func clearDoneTasks() {
		allTasks.filter { $0.status == .done }.forEach { doneTask in
			delete(doneTask)
		}
	}
}
