//
//  DetailViewModel.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-03-17.
//

import Foundation

extension DetailScreen {
	final class ViewModel: ObservableObject {
        @Published var task: TaskItem

        let parentVM: HomeViewModel

        init(for task: TaskItem, parentVM: HomeViewModel) {
            self.task = task
            self.parentVM = parentVM
        }

        func updateItemInItsSource() {
            parentVM.updateTasks(with: task)
        }

        func deleteTask() {
            // TODO: implement when persistence is deployed
            parentVM.delete(task)
        }

        func markTaskAsDone() {
            task.status = .done
            updateItemInItsSource()
        }
	}
}
