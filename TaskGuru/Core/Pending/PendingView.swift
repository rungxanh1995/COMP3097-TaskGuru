//
//  PendingView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-13.
//	Student ID: 101276573
//

import SwiftUI

struct PendingView: View {
	@StateObject private var tabState: AppState = .init()
	@State private var selectedTask: TaskItem?
	
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	
	private var noPendingTasksLeft: Bool {
		TaskItem.mockData.filter { $0.isNotDone }.isEmpty
	}
	
	var body: some View {
		NavigationStack(path: $tabState.navPath) {
			ZStack {
				if noPendingTasksLeft {
					emptyStateImage.padding()
				} else {
					List { pendingSection }
				}
			}
			.navigationDestination(for: TaskItem.self) { task in
				DetailView(task: task)
			}
			.navigationTitle("Pending Tasks")
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
			ForEach(TaskItem.mockData.filter {$0.isNotDone}) { task in
				NavigationLink(value: task) {
					// TODO: Replace by home list cell later
					Text(task.name)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: {
					if isPreviewEnabled {
						DetailView(task: task)
					} else {
						// TODO: Replace by home list cell later
						Text(task.name).padding()
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
				// mark task done
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
				// delete task
			} label: {
				Label { Text("Delete") } icon: { SFSymbols.trash }
			}
		} label: {
			Label { Text("Delete") } icon: { SFSymbols.trash }
		}
	}
}

struct PendingView_Previews: PreviewProvider {
	static var previews: some View {
		PendingView()
	}
}
