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
					TextField("addTask.input.name", text: $vm.taskName)
						.focused($focusField, equals: .name)

					VStack(alignment: .leading) {
						Text("addTask.input.dueDate")
						DatePicker("addTask.input.dueDate", selection: $vm.dueDate)
							.datePickerStyle(.graphical)
					}
					
					Picker("addTask.input.type", selection: $vm.taskType) {
						ForEach(TaskConstants.allTypes, id: \.self) {
							Text(LocalizedStringKey($0.rawValue))
						}
					}
					
					Picker("addTask.input.status", selection: $vm.taskStatus) {
						ForEach(TaskConstants.allStatuses, id: \.self) {
							Text(LocalizedStringKey($0.rawValue))
						}
					}

					Picker("addTask.input.priority", selection: $vm.taskPriority) {
						ForEach(TaskPriority.allCases, id: \.self) {
							Text(LocalizedStringKey($0.rawValue))
						}
					}
				} header: {
					Label {
						Text("addTask.sections.general")
					} icon: {
						SFSymbols.gridFilled
					}
				}
				
				Section {
					TextField(
						"addTask.input.notes",
						text: $vm.taskNotes,
						prompt: Text("addTask.input.placeholder.notes"),
						axis: .vertical
					)
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
			.navigationTitle("addTask.nav.title")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("addTask.nav.button.cancel") {
						haptic(.buttonPress)
						dismissThisView()
					}
				}
				
				ToolbarItem(placement: .confirmationAction) {
					Button("addTask.nav.button.add") {
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
		vm.addNewTask()
		haptic(.notification(.success))
	}
}

struct AddTask_Previews: PreviewProvider {
	static var previews: some View {
		AddTaskScreen(vm: .init(parentVM: dev.homeVM))
	}
}

