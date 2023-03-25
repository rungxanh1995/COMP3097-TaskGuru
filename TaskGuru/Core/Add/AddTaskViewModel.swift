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
		@Published var taskName: String = ""
		@Published var dueDate: Date = .now
		@Published var taskType: TaskType = .personal
		@Published var taskStatus: TaskStatus = .new
		@Published var taskNotes: String = ""

		private let listViewModel: HomeViewModel
				
		init(parentVM: HomeViewModel) {
			listViewModel = parentVM
		}

		func addTask(name: inout String, dueDate: Date, type: TaskType,
					 status: TaskStatus, notes: String) {
			assignDefaultTaskName(to: &name)
			listViewModel.addTask(name: &name, type: type, dueDate: dueDate, status: status, notes: notes)
		}

		fileprivate func assignDefaultTaskName(to name: inout String) {
			if name == "" { name = "Untitled Task" }
		}
	}
}
