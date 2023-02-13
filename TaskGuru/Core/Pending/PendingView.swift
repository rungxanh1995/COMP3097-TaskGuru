//
//  PendingView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-13.
//

import SwiftUI

struct PendingView: View {
	@EnvironmentObject private var appState: AppState
	@State private var selectedTask: TaskItem?
	
	private var noPendingTasksLeft: Bool {
		TaskItem.mockData.filter { $0.isNotDone }.isEmpty
	}
	
	var body: some View {
		NavigationStack(path: $appState.navPath) {
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
				} preview: { DetailView(task: task) }
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
			.environmentObject(AppState())
	}
}
