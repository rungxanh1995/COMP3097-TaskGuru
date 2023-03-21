//
//  DetailEditMode.swift
//  TaskGuru
//
//  Created by Ostap Sulyk on 2023-03-21.
//

import SwiftUI

extension DetailScreen {
    struct EditMode: View {
        internal enum FocusField { case name, notes }
        
        @FocusState private var focusField: FocusField?

        /// Needs this here, so we can navigate back to `Home` view after editing.
        /// Otherwise, we would see that the task info is not re-rendered in Detail View mode.
        @EnvironmentObject var appState: AppState
        @Environment(\.dismiss) var dismissThisView

        @ObservedObject var vm: DetailScreen.ViewModel

        var body: some View {
            NavigationView {
                Form {
                    Section {
                        TextField("Name", text: $vm.task.name)
                            .focused($focusField, equals: .name)

                        DatePicker("Due Date", selection: $vm.task.dueDate,
                                   displayedComponents: .date
                        )

                        Picker("Type", selection: $vm.task.type) {
                            ForEach(TaskConstants.allTypes, id: \.self) {
                                Text($0.rawValue)
                            }
                        }

                        Picker("Status", selection: $vm.task.status) {
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
                        TextField("Notes", text: $vm.task.notes, prompt: Text("Any extra notes..."), axis: .vertical)
                            .focused($focusField, equals: .notes)

                    } header: {
                        HStack {
                            SFSymbols.pencilDrawing
                            Text("Notes")
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focusField = .name
                    }
                }
                .onSubmit { focusField = nil }
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
                            didTapSaveButton()
                        }
                        .font(.headline)
                    }
                }
                .interactiveDismissDisabled()
            }
        }

        private func didTapSaveButton() -> Void {
            vm.updateItemInItsSource()
            dismissThisView()
            appState.popToRoot()
        }
    }
}
