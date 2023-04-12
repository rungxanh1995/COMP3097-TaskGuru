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
        @Published var task: TaskItem

        init(for task: TaskItem) {
            self.task = task
        }

        func updateItemInItsSource() {
						//TODO: logic to be implemented by OStap
            //parentVM.updateTasks(with: task)
        }

        func deleteTask() {
            // TODO: implement when persistence is deployed
					// parentVM.delete(task)
        }

        func markTaskAsDone() {
            task.status = .done
            updateItemInItsSource()
        }
	}
}
