//
//  AddTaskScreen.swift
//  TaskGuru
//
//  Created by Rauf Anata on 2023-02-16.
//  Student ID: 101220889
//

import SwiftUI

struct AddTaskScreen: View {
	@Environment(\.dismiss) var dismissThisView
	
	@ObservedObject var vm: AddTaskScreen.ViewModel
	
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
						ForEach(TaskType.allCases, id: \.self) {
							Text($0.rawValue)
						}
					}
					
					Picker("Status", selection: $statusSelected) {
						ForEach(TaskStatus.allCases, id: \.self) {
							Text($0.rawValue)
						}
					}
				} header: {
					Label { Text("General") } icon: { SFSymbols.gridFilled }
				}
				
				Section {
					TextField("Notes", text: $taskNotes, prompt: Text("Any extra notes..."), axis: .vertical)
				} header: {
					Label { Text("Notes") } icon: { SFSymbols.pencilDrawing }
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
		AddTaskScreen(vm: .init(parentVM: dev.homeVM))
	}
}

