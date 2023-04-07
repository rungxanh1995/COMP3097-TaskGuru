//
//  DetailView.swift
//  TaskGuru
//
//  Created by Ostap Sulyk on 2023-02-06.
//	Student ID: 101186901
//

import SwiftUI

extension DetailScreen {
	struct ViewMode: View {
		@ObservedObject var vm: DetailScreen.ViewModel

		@Environment(\.dismiss) var dismissThisView

		@State private var isShowingEdit: Bool = false
		@State private var isMarkingAsDone: Bool = false
		@State private var isDeletingTask: Bool = false

		private let columns = [
			GridItem(.flexible(minimum: 120.0, maximum: 600.0)),
			GridItem(.flexible(minimum: 120.0, maximum: 600.0))
		]

		var body: some View {
			ScrollView {
				VStack(spacing: 8) {
					LazyVGrid(columns: columns) {
						DetailGridCell(title: vm.task.name, caption: "Name")
						DetailGridCell(title: vm.task.status.rawValue, caption: "Status", titleColor: vm.task.colorForStatus())
						DetailGridCell(title: vm.task.shortDueDate, caption: "Due date", titleColor: vm.task.colorForDueDate())
						DetailGridCell(title: vm.task.type.rawValue, caption: "Type")
					}

					if vm.task.notes.isEmpty == false {
						DetailGridCell(title: vm.task.notes, caption: "Notes")
					}
				}
				.padding()

				Text("Last updated on \(vm.task.formattedLastUpdated)")
					.font(.system(.caption, design: .rounded))
					.foregroundColor(.secondary)
					.padding([.bottom])
			}
			.navigationTitle("Task Detail")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				if vm.task.isNotDone {
					ToolbarItemGroup(placement: .primaryAction) {
						Button(action: {isMarkingAsDone.toggle()}) {
							Label("Mark as Done", systemImage: "checkmark")
						}
					}
				}

				ToolbarItemGroup(placement: .secondaryAction) {
					Button(action: { isShowingEdit.toggle() }) {
						Label("Edit", systemImage: "square.and.pencil")
					}

					Button(action: {
						isDeletingTask.toggle()
						haptic(.notification(.warning))
					}) {
						Label("Delete", systemImage: "trash")
					}
				}
			}
			.alert("Mark Task as Done?", isPresented: $isMarkingAsDone, actions: {
				Button("Cancel", role: .cancel, action: {})
				Button("OK", action: {
					vm.markTaskAsDone()
					dismissThisView()
					haptic(.notification(.success))
				})
			})
			.alert("Delete Task?", isPresented: $isDeletingTask, actions: {
				Button("Cancel", role: .cancel, action: {})
				Button("OK", action: {
					vm.deleteTask()
					dismissThisView()
					haptic(.notification(.success))
				})
			})
			.sheet(isPresented: $isShowingEdit) {
				DetailScreen.EditMode(vm: self.vm)
			}
		}
	}
}
