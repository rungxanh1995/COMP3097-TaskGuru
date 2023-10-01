//
//  PendingScreen.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-16.
//	Student ID: 101276573
//

import SwiftUI

struct PendingScreen: View {
	@EnvironmentObject private var vm: HomeViewModel
	@StateObject private var tabState: AppState = .init()
	@State private var selectedTask: TaskItem?

	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@State private var confettiCounter: Int = 0

	@Preference(\.isTodayDuesHighlighted) private var duesHighlighted
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	@Preference(\.contextPreviewType) private var previewType

	var body: some View {
		NavigationStack(path: $tabState.navPath) {
			ZStack {
				if vm.noPendingTasksLeft {
					emptyStateImage().padding()
				} else {
					List {
						pendingInThePastSection
						pendingTodaySection
						pendingFromTomorrowSection
						encouragingMessage.listRowBackground(Color.clear)
					}
					.accessibilityElement(children: .contain)
				}
			}
			.listStyle(.plain)
			.playConfetti($confettiCounter)
			.navigationDestination(for: TaskItem.self) { task in
				DetailScreen(vm: .init(for: task))
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .principal) {
					NavigationTitle(text: "pending.nav.title")
				}
				ToolbarItem(placement: .primaryAction) {
					addTaskButton
				}
			}
			.sheet(isPresented: $vm.isShowingAddTaskView) {
				AddTaskScreen(vm: .init(parentVM: self.vm))
			}
			.fullScreenCover(item: $selectedTask) { task in
				DetailScreen(vm: .init(for: task))
			}
		}
		.environmentObject(tabState)
	}
}

extension PendingScreen {
	private func emptyStateImage(alignment: HorizontalAlignment = .center) -> some View {
		VStack(alignment: alignment) {
			makeCheerfulDecorativeImage()
			
			Text("pending.info.listEmty")
				.font(.callout)
				.foregroundStyle(.secondary)
		}
	}
	
	private var encouragingMessage: some View {
		Text("pending.info.listNotEmpty")
			.font(.footnote)
			.foregroundStyle(.secondary)
	}
	
	@ViewBuilder private var pendingInThePastSection: some View {
		let pendings = vm.pendingTasks.filter { $0.dueDate.isPastToday }
		
		if pendings.isEmpty == false {
			Section {
				filteredList(of: pendings)
			} header: {
				Text("pending.sections.overdue").bold().foregroundStyle(Color.appPink)
			}
		}
	}
	
	@ViewBuilder private var pendingTodaySection: some View {
		let pendings = vm.pendingTasks.filter { $0.dueDate.isWithinToday }
		
		Section {
			if pendings.isEmpty == false {
				filteredList(of: pendings)
					.if(duesHighlighted) { list in
						list.listRowBackground(DynamicHighlightBackground())
					}
			} else {
				// leading alignment to workaround weird-looking list separator
				emptyStateImage(alignment: .leading).listRowBackground(Color.clear)
			}
		} header: {
			Text("pending.sections.dueToday").bold().foregroundStyle(Color.appYellow)
		}
	}
	
	@ViewBuilder private var pendingFromTomorrowSection: some View {
		let pendings = vm.pendingTasks.filter { $0.dueDate.isFromTomorrow }
		
		if pendings.isEmpty == false {
			Section {
				filteredList(of: pendings)
			} header: {
				Text("pending.sections.upcoming").bold().foregroundStyle(Color.appClover)
			}
		}
	}
	
	@ViewBuilder
	private func filteredList(of tasks: [TaskItem]) -> some View {
		ForEach(tasks) { task in
			NavigationLink(value: task) {
				HomeListCell(task: task)
			}
			.if(isPreviewEnabled) { listCell in
				listCell.if(ContextPreviewType(rawValue: previewType) == .cell) { cell in
					cell.contextMenu { makeContextMenu(for: task) }
				} elseCase: { cell in
					cell.contextMenu { makeContextMenu(for: task) } preview: {
						DetailScreen(vm: .init(for: task))
					}
				}
			}
			.swipeActions(edge: .leading) {
				switch task.status {
				case .new: markInProgressButton(for: task).tint(.appYellow)
				case .inProgress: markNewButton(for: task).tint(.appClover)
				case .done: EmptyView()
				}
			}
			.swipeActions(edge: .trailing, allowsFullSwipe: true) {
				deleteButton(for: task).tint(.appPink)
				// all tasks in this view are pending ones,
				// so no need to conditional check to render this button
				markDoneButton(for: task).tint(.appIndigo)
			}
		}
	}
	
	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		markAsButtons(for: task)
		
		Button {
			selectedTask = task
		} label: {
			Label { Text("contextMenu.task.edit") } icon: { SFSymbols.pencilSquare }
		}
		
		Menu {
			Button(role: .cancel) {} label: {
				Label { Text("contextMenu.cancel") } icon: { SFSymbols.xmark }
			}
			Button(role: .destructive) {
				withAnimation { vm.delete(task) }
				haptic(.notification(.success))
			} label: {
				Label { Text("contextMenu.task.delete") } icon: { SFSymbols.trash }
			}
		} label: {
			Label { Text("contextMenu.task.delete") } icon: { SFSymbols.trash }
		}
	}
	
	@ViewBuilder private func markAsButtons(for task: TaskItem) -> some View {
		switch task.status {
		case .new:
			Section {
				markInProgressButton(for: task)
				markDoneButton(for: task)
			} header: { Text("contextMenu.task.markAs") }
		case .inProgress:
			Section {
				markNewButton(for: task)
				markDoneButton(for: task)
			} header: { Text("contextMenu.task.markAs") }
		case .done:
			EmptyView()
		}
	}
	
	private func markNewButton(for task: TaskItem) -> some View {
		Button {
			withAnimation { vm.markAsNew(task) }
			haptic(.notification(.success))
		} label: {
			Label {
				Text("contextMenu.task.markNew")
			} icon: { SFSymbols.sparkles }
		}
	}
	
	private func markInProgressButton(for task: TaskItem) -> some View {
		Button {
			withAnimation { vm.markAsInProgress(task) }
			haptic(.notification(.success))
		} label: {
			Label {
				Text("contextMenu.task.markInProgress")
			} icon: { SFSymbols.circleArrows }
		}
	}
	
	private func markDoneButton(for task: TaskItem) -> some View {
		Button {
			withAnimation { vm.markAsDone(task) }
			if isConfettiEnabled { confettiCounter += 1 }
			haptic(.notification(.success))
		} label: {
			Label {
				Text("contextMenu.task.markDone")
			} icon: { SFSymbols.checkmark }
		}
	}
	
	private func deleteButton(for task: TaskItem) -> some View {
		Button(role: .destructive) {
			withAnimation { vm.delete(task) }
			haptic(.notification(.success))
		} label: {
			Label {
				Text("contextMenu.task.delete")
			} icon: { SFSymbols.trash }
		}
	}
	
	private var addTaskButton: some View {
		Button {
			vm.isShowingAddTaskView.toggle()
		} label: {
			Label { Text("label.task.add") } icon: { SFSymbols.plus }
		}
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
		.accessibilityHint("Tap this button to toggle Add new task screen")
	}
}

struct PendingView_Previews: PreviewProvider {
	static var previews: some View {
		PendingScreen()
			.environmentObject(HomeViewModel())
	}
}
