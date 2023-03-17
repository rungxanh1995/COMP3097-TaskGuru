//
//  DetailViewModel.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-03-17.
//

import Foundation

extension DetailScreen {
	final class ViewModel: ObservableObject {
		let parentVM: HomeViewModel

		init(for task: TaskItem, parentVM: HomeViewModel) {
			self.parentVM = parentVM
		}
	}
}
