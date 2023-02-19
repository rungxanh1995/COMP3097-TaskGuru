//
//  PendingView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-16.
//	Student ID: 101276573
//

import SwiftUI
import ConfettiSwiftUI

struct PendingView: View {
	@StateObject private var tabState: AppState = .init()
	@State private var selectedTask: TaskItem?
	private var noPendingTasksLeft: Bool {
		TaskItem.mockData.filter { $0.isNotDone }.isEmpty
	}
	
	@State private var isShowingAddTaskView: Bool = false
	
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@State private var confettiCounter: Int = 0
	
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	
	var body: some View {
		NavigationStack(path: $tabState.navPath) {
			ZStack {
				if noPendingTasksLeft {
					emptyStateImage.padding()
				} else {
					List { pendingSection }
				}
			}
			.confettiCannon(counter: $confettiCounter)
			.navigationDestination(for: TaskItem.self) { task in
				DetailView(task: task)
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					GradientNavigationTitle(text: "Pending Tasks")
				}

				ToolbarItem(placement: .primaryAction) {
					addTaskButton
				}
			}
			.sheet(isPresented: $isShowingAddTaskView) {
				AddTask()
			}
			.fullScreenCover(item: $selectedTask) { task in
				EditView()
			}
		}
		.environmentObject(tabState)
	}
}

extension PendingView {
	private var emptyStateImage: some View {
		VStack {
			makeCheerfulDecorativeImage()
			
			Text("You're free! Enjoy your much deserved time 🥳")
				.font(.footnote)
				.foregroundColor(.secondary)
		}
	}
	
	private var pendingSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.isNotDone }) { task in
				NavigationLink(value: task) {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: {
					if isPreviewEnabled {
						DetailView(task: task)
					} else {
						HomeListCell(task: task).padding()
					}
				}
			}
		} footer: {
			Text("Don't stress yourself too much. You got it 💪")
		}
		.headerProminence(.increased)
	}
	
	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		if task.isNotDone {
			Button {
				// Mark as done here
				if isConfettiEnabled { confettiCounter += 1 }
			} label: {
				Label { Text("Mark as Done") } icon: { SFSymbols.checkmark }
			}
		}
		Button { selectedTask = task } label: {
			Label { Text("Edit") } icon: { SFSymbols.pencilSquare }
		}
		Divider()
		
		Menu {
			Button(role: .cancel) {} label: {
				Label { Text("Cancel") } icon: { SFSymbols.xmark }
			}
			Button(role: .destructive) {
				// Delete task here
			} label: {
				Label { Text("Delete") } icon: { SFSymbols.trash }
			}
		} label: {
			Label { Text("Delete") } icon: { SFSymbols.trash }
		}
	}
	
	private var addTaskButton: some View {
		Button {
			isShowingAddTaskView.toggle()
		} label: {
			Label { Text("Add Task") } icon: { SFSymbols.plus }
		}
	}
}

struct PendingView_Previews: PreviewProvider {
	static var previews: some View {
		PendingView()
	}
}
