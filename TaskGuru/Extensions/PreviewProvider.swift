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
	let task: TaskItem = .init(name: "Group project presentation", dueDate: .now, lastUpdated: .now, type: .school, status: .inProgress, notes: "An advanced ToDo application with several types of tasks and ability to create new tasks and new kinds of tasks.")
}
