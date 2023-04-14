//
//  DetailViewModel.swift
//  TaskGuru
//
//  Created by Ostap Sulyk on 2023-03-17.
//  Student ID: 101186901
//

import Foundation

extension DetailScreen {
	final class ViewModel: ObservableObject {
        var task: TaskItem

        // MARK: - Edit Mode
        @Published var taskName: String
        @Published var taskDueDate: Date
        @Published var taskType: TaskType
        @Published var taskStatus: TaskStatus
        @Published var taskPriority: TaskPriority
        @Published var taskNotes: String

        private let storageProvider: StorageProvider

        init(for task: TaskItem, storageProvider: StorageProvider = StorageProviderImpl.standard) {
            self.task = task
            self.storageProvider = storageProvider

            taskName = task.name
            taskDueDate = task.dueDate
            taskType = task.type
            taskStatus = task.status
            taskPriority = task.priority
            taskNotes = task.notes
        }

        func updateTask() {
            task.name = taskName
            task.dueDate = taskDueDate
            task.type = taskType
            task.status = taskStatus
            task.priority = taskPriority
            task.notes = taskNotes
            saveAndHandleError()
        }

        func deleteTask() {
            storageProvider.context.delete(task)
            saveAndHandleError()
        }

        private func saveAndHandleError() {
            storageProvider.saveAndHandleError()
        }

        func markTaskAsDone() {
            task.status = .done
            saveAndHandleError()
        }
	}
}
