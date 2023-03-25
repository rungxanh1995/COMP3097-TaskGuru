//
//  AddTaskScreen.swift
//  TaskGuru
//
//  Created by Rauf Anata on 2023-02-16.
//  Student ID: 101220889
//

import SwiftUI

struct AddTaskScreen: View {
	internal enum FocusField { case name, notes }
	@FocusState private var focusField: FocusField?

	@Environment(\.dismiss) var dismissThisView
	
	@ObservedObject var vm: AddTaskScreen.ViewModel
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Name", text: $vm.taskName)
						.focused($focusField, equals: .name)

					DatePicker("Due Date", selection: $vm.dueDate,
										 displayedComponents: .date
					)
					
					Picker("Type", selection: $vm.taskType) {
						ForEach(TaskType.allCases, id: \.self) {
							Text($0.rawValue)
						}
					}
					
					Picker("Status", selection: $vm.taskStatus) {
						ForEach(TaskStatus.allCases, id: \.self) {
							Text($0.rawValue)
						}
					}
				} header: {
					Label { Text("General") } icon: { SFSymbols.gridFilled }
				}
				
				Section {
					TextField("Notes", text: $vm.taskNotes, prompt: Text("Any extra notes..."), axis: .vertical)
						.focused($focusField, equals: .notes)
				} header: {
					Label { Text("Notes") } icon: { SFSymbols.pencilDrawing }
				}
			}
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					focusField = .name
				}
			}
			.onSubmit { focusField = nil }
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
						addNewTask()
						dismissThisView()
					}
				}
			}
		}
		.interactiveDismissDisabled()
	}
}

extension AddTaskScreen {
	private func addNewTask() -> Void {
		vm.addTask(name: &vm.taskName, dueDate: vm.dueDate, type: vm.taskType,
							 status: vm.taskStatus, notes: vm.taskNotes)
	}
}

struct AddTask_Previews: PreviewProvider {
	static var previews: some View {
		AddTaskScreen(vm: .init(parentVM: dev.homeVM))
	}
}

