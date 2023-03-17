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
				
		init(parentVM: HomeViewModel) {
			listViewModel = parentVM
		}
	}
}
