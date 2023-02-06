//
//  EditView.swift
//  TaskGuru
//
//  Created by Ostap Sulyk on 2023-02-06.
//

import SwiftUI

struct EditView: View {
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
					
					DatePicker("Due Date", selection: $taskDueDate,
										 in: TaskConstants.dateRangeFromToday,
										 displayedComponents: .date
					)
					
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
			.navigationTitle("Edit Task")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") {
						dismissThisView()
					}
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Save") {
						// add task then dismiss view
						dismissThisView()
					}
					.font(.headline)
				}
			}
		}
		.interactiveDismissDisabled()
	}
}

struct EditView_Previews: PreviewProvider {
	static var previews: some View {
		EditView()
	}
}
