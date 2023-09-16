//
//  HomeScreen.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-04-12.
//  Student ID: 101307949
//

import SwiftUI

struct HomeScreen: View {
	@EnvironmentObject var vm: HomeViewModel
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
				if vm.isFetchingData {
					ProgressView { Text("pending.info.fetchingData") }
				} else if vm.allTasks.isEmpty {
					emptyTaskText.padding()
				} else {
					List {
						overdueSection
						dueTodaySection
						upcomingSection
					}
				}
			}
			.listStyle(.plain)
			.playConfetti($confettiCounter)
			.onAppear(perform: vm.fetchTasks)
			.onChange(of: selectedTask) { _ in vm.fetchTasks() }
			.navigationDestination(for: TaskItem.self) { task in
				DetailScreen(vm: .init(for: task))
			}
			.navigationBarTitleDisplayMode(.inline)
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
			.fullScreenCover(isPresented: $vm.isShowingAddTaskView) {
				AddTaskScreen(vm: .init(parentVM: self.vm))
			}
			.fullScreenCover(item: $selectedTask) { task in
				DetailScreen.EditMode(vm: .init(for: task))
			}
			.confirmationDialog(
				"home.clearDoneTasks.alert",
				isPresented: $vm.isConfirmingClearDoneTasks,
				titleVisibility: .visible
			) {
				Button("contextMenu.clearDoneTasks", role: .destructive) {
					vm.clearDoneTasks()
					haptic(.notification(.success))
				}
				Button("contextMenu.cancel", role: .cancel) {
					haptic(.buttonPress)
				}
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
		let emptyListSentence = LocalizedStringKey("home.info.sectionEmpty")
		Text(emptyListSentence)
			.font(.callout)
			.foregroundColor(.secondary)
	}

	@ViewBuilder private var overdueSection: some View {
		Section {
			let overdues = vm.searchResults.filter { $0.dueDate.isPastToday }

			if overdues.isEmpty {
				emptyFilteredListText
			} else {
				filteredList(of: overdues)
			}
		} header: {
			Text("home.sections.overdue").bold().foregroundColor(.appPink)
		}
	}

	@ViewBuilder private var dueTodaySection: some View {
		Section {
			let dues = vm.searchResults.filter { $0.dueDate.isWithinToday }

			if dues.isEmpty {
				emptyFilteredListText
			} else {
				filteredList(of: dues)
					.if(duesHighlighted) { list in
						list
							.listRowBackground(DynamicHighlightBackground())
					}
			}
		} header: {
			Text("home.sections.dueToday").bold().foregroundColor(.appYellow)
		}
	}

	@ViewBuilder private var upcomingSection: some View {
		Section {
			let upcomings = vm.searchResults.filter { $0.dueDate.isFromTomorrow }

			if upcomings.isEmpty {
				emptyFilteredListText
			} else {
				filteredList(of: upcomings)
			}
		} header: {
			Text("home.sections.upcoming").bold().foregroundColor(.appClover)
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
				case .new:
					markInProgressButton(for: task).tint(.appYellow)
				case .inProgress:
					markNewButton(for: task).tint(.appClover)
				case .done:
					markNewButton(for: task).tint(.appClover)
					markInProgressButton(for: task).tint(.appYellow)
				}
			}
			.swipeActions(edge: .trailing, allowsFullSwipe: true) {
				deleteButton(for: task).tint(.appPink)
				if task.isNotDone {
					markDoneButton(for: task).tint(.appIndigo)
				}
			}
		}
	}

	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		markAsButtons(for: task)
		Button {
			selectedTask = task
			haptic(.buttonPress)
		} label: {
			Label { Text("contextMenu.task.edit") } icon: { SFSymbols.pencilSquare }
		}

		Menu {
			Button(role: .cancel) {
				haptic(.buttonPress)
			} label: {
				Label { Text("contextMenu.cancel") } icon: { SFSymbols.xmark }
			}
			deleteButton(for: task)
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
			Section {
				markNewButton(for: task)
				markInProgressButton(for: task)
			} header: { Text("contextMenu.task.markAs") }
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

	private var todaysDate: some View {
		Label {
			Text(Date().formatted(.dateTime.weekday().day()))
				.bold()
		} icon: {
			SFSymbols.calendarWithClock
		}
		.labelStyle(.titleAndIcon)
		.foregroundColor(.appYellow)
	}

	private var addTaskButton: some View {
		Button {
			haptic(.buttonPress)
			vm.isShowingAddTaskView.toggle()
		} label: {
			Label { Text("label.task.add") } icon: { SFSymbols.plus }
		}
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
	}

	private var clearDoneTasksButton: some View {
		Button(role: .destructive) {
			haptic(.notification(.warning))
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
