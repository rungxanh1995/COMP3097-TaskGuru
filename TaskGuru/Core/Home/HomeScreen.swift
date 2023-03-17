//
//  HomeScreen.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-02-17.
//  Student ID: 101307949
//

import SwiftUI

struct HomeScreen: View {
	@EnvironmentObject private var vm: HomeViewModel
	@StateObject private var tabState: AppState = .init()
	@State private var selectedTask: TaskItem?
	
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@State private var confettiCounter: Int = 0
	
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	@Preference(\.contextPreviewType) private var previewType
	
	var body: some View {
		NavigationStack(path: $tabState.navPath) {
			List {
				if vm.allTasks.isEmpty {
					emptyTaskText
				} else {
					overdueSection
					dueTodaySection
					upcomingSection
				}
			}
			.listStyle(.plain)
			.playConfetti($confettiCounter)
			.onChange(of: selectedTask) { _ in
				guard let selectedTask else { return }
				vm.updateTasks(with: selectedTask)
			}
			.navigationDestination(for: TaskItem.self) { task in
				DetailScreen(vm: .init(for: task, parentVM: vm), task: task)
			}
			.navigationTitle("TaskGuru")
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					todaysDate
				}
				ToolbarItem(placement: .principal) {
					NavigationTitle(text: "home.nav.title")
				}
				ToolbarItem(placement: .primaryAction) {
					addTaskButton
				}
				ToolbarItem(placement: .secondaryAction) {
					clearDoneTasksButton
				}
			}
			.searchable(text: $vm.searchText)
			.sheet(isPresented: $vm.isShowingAddTaskView) {
				AddTaskScreen(vm: .init(parentVM: self.vm))
			}
			.fullScreenCover(item: $selectedTask) { task in
				DetailScreen(vm: .init(for: task, parentVM: vm), task: task)
			}
		}
		.environmentObject(tabState)
	}
}

extension HomeScreen {
	private var emptyTaskText: some View {
		VStack {
			makeCheerfulDecorativeImage()
			
			let emptyTaskListSentence = LocalizedStringKey("Nothing yet. Tap here or \(SFSymbols.plusCircled) to add more")
			Text(emptyTaskListSentence)
				.font(.callout)
				.foregroundColor(.secondary)
		}
		.onTapGesture { vm.isShowingAddTaskView.toggle() }
	}
	
	@ViewBuilder private var emptyFilteredListText: some View {
		let emptyListSentence = LocalizedStringKey("No tasks")
		Text(emptyListSentence)
			.font(.callout)
			.foregroundColor(.secondary)
	}
	
	@ViewBuilder
	private var overdueSection: some View {
		Section {
			let overdues = vm.searchResults.filter { $0.dueDate.isPastToday }
			
			if overdues.isEmpty {
				emptyFilteredListText
			} else {
				filteredList(of: overdues)
			}
		} header: {
			Text("home.sections.overdue").bold().foregroundColor(.pink)
		}
	}
	
	@ViewBuilder
	private var dueTodaySection: some View {
		Section {
			let dues = vm.searchResults.filter { $0.dueDate.isWithinToday }
			
			if dues.isEmpty {
				emptyFilteredListText
			} else {
				filteredList(of: dues)
			}
		} header: {
			Text("home.sections.dueToday").bold().foregroundColor(.yellow)
		}
	}
	
	@ViewBuilder
	private var upcomingSection: some View {
		Section {
			let upcomings = vm.searchResults.filter { $0.dueDate.isFromTomorrow }
			
			if upcomings.isEmpty {
				emptyFilteredListText
			} else {
				filteredList(of: upcomings)
			}
		} header: {
			Text("home.sections.upcoming").bold().foregroundColor(.teal)
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
						DetailScreen(vm: .init(for: task, parentVM: vm), task: task)
					}
				}
			}
			.swipeActions(edge: .leading) {
				switch task.status {
				case .new:
					markInProgressButton(for: task).tint(.yellow)
				case .inProgress:
					markNewButton(for: task).tint(.teal)
				case .done:
					markNewButton(for: task).tint(.teal)
					markInProgressButton(for: task).tint(.yellow)
				}
			}
			.swipeActions(edge: .trailing, allowsFullSwipe: true) {
				deleteButton(for: task).tint(.pink)
				if task.isNotDone {
					markDoneButton(for: task).tint(.indigo)
				}
			}
		}
	}
	
	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		if task.isNotDone {
			Button {
				withAnimation { vm.markAsDone(task) }
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
				withAnimation { vm.delete(task) }
			} label: {
				Label { Text("Delete") } icon: { SFSymbols.trash }
			}
		} label: {
			Label { Text("Delete") } icon: { SFSymbols.trash }
		}
	}
	
	private func markNewButton(for task: TaskItem) -> some View {
		Button {
			withAnimation { vm.markAsNew(task) }
			haptic(.success)
		} label: {
			Label {
				Text("contextMenu.task.markNew")
			} icon: { SFSymbols.sparkles }
		}
	}
	
	private func markInProgressButton(for task: TaskItem) -> some View {
		Button {
			withAnimation { vm.markAsInProgress(task) }
			haptic(.success)
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
			haptic(.success)
		} label: {
			Label {
				Text("contextMenu.task.markDone")
			} icon: { SFSymbols.checkmark }
		}
	}
	
	private func deleteButton(for task: TaskItem) -> some View {
		Button(role: .destructive) {
			withAnimation { vm.delete(task) }
			haptic(.success)
		} label: {
			Label {
				Text("contextMenu.task.delete")
			} icon: { SFSymbols.trash }
		}
	}
	
	private var todaysDate: some View {
		Label {
			Text(Date().formatted(.dateTime.weekday().day()))
				.bold()
		} icon: {
			SFSymbols.calendarWithClock
		}
		.labelStyle(.titleAndIcon)
		.foregroundColor(.yellow)
	}
	
	private var addTaskButton: some View {
		Button {
			vm.isShowingAddTaskView.toggle()
		} label: {
			Label { Text("Add Task") } icon: { SFSymbols.plus }
		}
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
	}

	private var clearDoneTasksButton: some View {
		Button(role: .destructive) {
			haptic(.warning)
			withAnimation { vm.isConfirmingClearDoneTasks.toggle() }
		} label: {
			Label { Text("contextMenu.clearDoneTasks") } icon: { SFSymbols.trash }
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeScreen()
			.environmentObject(HomeViewModel())
	}
}
