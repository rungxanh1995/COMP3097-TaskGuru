//
//  AddTask.swift
//  TaskGuru
//
//  Created by Rauf Anata on 2023-02-16.
//  Student ID: 101220889
//

import SwiftUI

struct AddTask: View {
	@Environment(\.dismiss) var dismissThisView
	
	@State private var taskName: String = ""
	@State private var dueDate: Date = .init()
	@State private var taskTypeSelected: TaskType = .personal
	@State private var statusSelected: TaskStatus = .new
	@State private var taskNotes = ""
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Name", text: $taskName)
					
					DatePicker("Due Date", selection: $dueDate,
										 displayedComponents: .date
					)
					
					Picker("Type", selection: $taskTypeSelected) {
						ForEach(TaskConstants.allTypes, id: \.self) {
							Text($0.rawValue)
						}
					}
					
					Picker("Status", selection: $statusSelected) {
						ForEach(TaskConstants.allStatuses, id: \.self) {
							Text($0.rawValue)
						}
					}
				} header: {
					HStack {
						SFSymbols.gridFilled
						Text("General")
					}
				}
				
				Section {
					TextField("Notes", text: $taskNotes, prompt: Text("Any extra notes..."), axis: .vertical)
				} header: {
					HStack {
						SFSymbols.pencilDrawing
						Text("Notes")
					}
				}
			}
			.navigationTitle("Add Task")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismissThisView()
					}
				}
				
				ToolbarItem(placement: .confirmationAction) {
					Button("Add") {
						// add task then dismiss view
						dismissThisView()
					}
				}
			}
		}
		.interactiveDismissDisabled()
	}
}

struct AddTask_Previews: PreviewProvider {
	static var previews: some View {
		AddTask()
	}
}

