//
//  AddTaskScreen.swift
//  TaskGuru
//
//  Created by Rauf Anata on 2023-03-16.
//  Student ID: 101220889
//

import Foundation

extension AddTaskScreen {
	final class ViewModel: ObservableObject {
		private let listViewModel: HomeViewModel
		private let storageProvider: StorageProvider
		
		init(parentVM: HomeViewModel, storageProvider: StorageProvider = StorageProviderImpl.standard) {
			listViewModel = parentVM
			self.storageProvider = storageProvider
		}

		@Published var taskName: String = ""
		@Published var dueDate: Date = .endOfDay
		@Published var taskType: TaskType = .personal
		@Published var taskStatus: TaskStatus = .new
		@Published var taskPriority: TaskPriority = .none
		@Published var taskNotes: String = ""
		
		func addNewTask() {
			addTask(
				name: &taskName, dueDate: dueDate, type: taskType,
				status: taskStatus, priority: taskPriority, notes: taskNotes
			)
		}

		/// Helper method to gather all information needed to create a new task, and add to persistence
		private func addTask(
			name: inout String, dueDate: Date, type: TaskType,
			status: TaskStatus, priority: TaskPriority, notes: String
		) {
			assignDefaultTaskName(to: &name)
			
			let newTask = TaskItem(context: storageProvider.context)
			newTask.id = UUID()
			newTask.name = name
			newTask.dueDate = dueDate
			newTask.lastUpdated = .now
			newTask.type = type
			newTask.status = status
			newTask.priority = priority
			newTask.notes = notes

			saveThenRefetchData()
		}

		fileprivate func assignDefaultTaskName(to name: inout String) {
			if name == "" { name = "Untitled Task" }
		}

		fileprivate func saveThenRefetchData() {
			storageProvider.saveAndHandleError()
			listViewModel.fetchTasks()
		}
	}
}
