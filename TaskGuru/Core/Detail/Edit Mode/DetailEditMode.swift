//
//  DetailEditMode.swift
//  TaskGuru
//
//  Created by Ostap Sulyk on 2023-03-21.
//  Student ID: 101186901
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
                        TextField("editTask.input.name", text: $vm.taskName)
                            .focused($focusField, equals: .name)

                        VStack(alignment: .leading) {
                            Text("editTask.input.dueDate")
                            DatePicker("editTask.input.dueDate", selection: $vm.taskDueDate)
                                .datePickerStyle(.graphical)
                        }

                        Picker("editTask.input.type", selection: $vm.taskType) {
                            ForEach(TaskType.allCases, id: \.self) {
                                Text(LocalizedStringKey($0.rawValue))
                            }
                        }

                        Picker("editTask.input.status", selection: $vm.taskStatus) {
                            ForEach(TaskStatus.allCases, id: \.self) {
                                Text(LocalizedStringKey($0.rawValue))
                            }
                        }

                        Picker("editTask.input.priority", selection: $vm.taskPriority) {
                            ForEach(TaskPriority.allCases, id: \.self) {
                                Text(LocalizedStringKey($0.rawValue))
                            }
                        }
                    } header: {
                        Label {
                            Text("editTask.sections.general")
                        } icon: {
                            SFSymbols.gridFilled
                        }
                    }

                    Section {
                        TextField("editTask.input.notes", text: $vm.taskNotes,
                                            prompt: Text("editTask.input.placeholder.notes"),
                                            axis: .vertical)
                            .focused($focusField, equals: .notes)

                    } header: {
                        Label {
                            Text("editTask.sections.notes")
                        } icon: {
                            SFSymbols.gridFilled
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focusField = .name
                    }
                }
                .onSubmit { focusField = nil }
                .navigationTitle("editTask.nav.title")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("editTask.nav.button.cancel") {
                            haptic(.buttonPress)
                            dismissThisView()
                        }
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button("editTask.nav.button.save") {
                            didTapSaveButton()
                        }
                        .font(.headline)
                    }

                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button {
                            focusField = nil
                        } label: { SFSymbols.keyboardChevronDown }
                    }
                }
            }
            .interactiveDismissDisabled()
        }

        private func didTapSaveButton() -> Void {
            vm.updateTask()
            dismissThisView()
            appState.popToRoot()
            haptic(.notification(.success))
        }
    }
}
