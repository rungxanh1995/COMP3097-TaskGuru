//
//  EditView.swift
//  TaskGuru
//
//  Created by Ostap Sulyk on 2023-02-06.
//	Student ID: 101186901
//

import SwiftUI

struct EditView: View {
	internal enum FocusField { case name, notes }
	@FocusState private var focusField: FocusField?

	@Environment(\.dismiss) var dismissThisView
	
	@State private var taskName: String = ""
	@State private var taskDueDate: Date = .init()
	@State private var taskTypeSelected = TaskType.personal
	@State private var taskStatusSelected = TaskStatus.inProgress
	@State private var taskNotes = ""
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Name", text: $taskName)
						.focused($focusField, equals: .name)
					
					DatePicker("Due Date", selection: $taskDueDate,
										 displayedComponents: .date)

					Picker("Type", selection: $taskTypeSelected) {
						ForEach(TaskConstants.allTypes, id: \.self) {
							Text($0.rawValue)
						}
					}
					
					Picker("Status", selection: $taskStatusSelected) {
						ForEach(TaskConstants.allStatuses, id: \.self) {
							Text($0.rawValue)
						}
					}
				} header: {
					Label {
						Text("General")
					} icon: {
						SFSymbols.gridFilled
					}
				}
				
				Section {
					TextField("Notes", text: $taskNotes, prompt: Text("Any extra notes..."), axis: .vertical)
				} header: {
					Label {
						Text("Notes")
					} icon: {
						SFSymbols.pencilDrawing
					}
				}
			}
			.onSubmit { focusField = nil }
			.navigationTitle("Edit Task")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismissThisView()
					}
				}
				
				ToolbarItem(placement: .confirmationAction) {
					Button("Save") {
						didTapSaveButton()
					}
				}
			}
		}
		.interactiveDismissDisabled()
	}
}

extension EditView {
	private func didTapSaveButton() {
		// add task here...
		dismissThisView()
	}
}

struct EditView_Previews: PreviewProvider {
	static var previews: some View {
		EditView()
	}
}
