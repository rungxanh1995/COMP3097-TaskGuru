//
//  PendingView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-16.
//	Student ID: 101276573
//

import SwiftUI

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
	@Preference(\.contextPreviewType) private var previewType
	
	var body: some View {
		NavigationStack(path: $tabState.navPath) {
			ZStack {
				if noPendingTasksLeft {
					emptyStateImage.padding()
				} else {
					List {
						pendingInThePastSection
						pendingTodaySection
						pendingFromTomorrowSection
						encouragingMessage.listRowBackground(Color.clear)
					}
				}
			}
			.playConfetti($confettiCounter)
			.navigationDestination(for: TaskItem.self) { task in
				DetailView(task: task)
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

			Text("pending.info.listEmty")
				.font(.callout)
				.foregroundColor(.secondary)
		}
	}

	private var encouragingMessage: some View {
		Text("pending.info.listNotEmpty")
			.font(.footnote)
			.foregroundColor(.secondary)
	}

	@ViewBuilder private var pendingInThePastSection: some View {
		let pendings = TaskItem.mockData
			.filter { $0.dueDate.isPastToday && $0.isNotDone }
		
		if pendings.isEmpty == false {
			Section {
				ForEach(pendings) { task in
					NavigationLink(value: task) {
						HomeListCell(task: task)
					}
					.if(isPreviewEnabled) { view in
						view.if(ContextPreviewType(rawValue: previewType) == .cell) { view in
							view.contextMenu { makeContextMenu(for: task) }
						} elseCase: { view in
							view.contextMenu {
								makeContextMenu(for: task)
							} preview: { DetailView(task: task) }
						}
					}
				}
			} header: {
				Text("pending.sections.overdue").bold().foregroundColor(.red)
			}
		}
	}

	@ViewBuilder private var pendingTodaySection: some View {
		let pendings = TaskItem.mockData
			.filter { $0.dueDate.isWithinToday && $0.isNotDone }
		
		if pendings.isEmpty == false {
			Section {
				ForEach(pendings) { task in
					NavigationLink(value: task) {
						HomeListCell(task: task)
					}
					.if(isPreviewEnabled) { view in
						view.if(ContextPreviewType(rawValue: previewType) == .cell) { view in
							view.contextMenu { makeContextMenu(for: task) }
						} elseCase: { view in
							view.contextMenu {
								makeContextMenu(for: task)
							} preview: { DetailView(task: task) }
						}
					}
				}
			} header: {
				Text("pending.sections.dueToday").bold().foregroundColor(.orange)
			}
		}
	}
	
	@ViewBuilder private var pendingFromTomorrowSection: some View {
		let pendings = TaskItem.mockData
			.filter { $0.dueDate.isFromTomorrow && $0.isNotDone }
		
		if pendings.isEmpty == false {
			Section {
				ForEach(pendings) { task in
					NavigationLink(value: task) {
						HomeListCell(task: task)
					}
					.if(isPreviewEnabled) { view in
						view.if(ContextPreviewType(rawValue: previewType) == .cell) { view in
							view.contextMenu { makeContextMenu(for: task) }
						} elseCase: { view in
							view.contextMenu {
								makeContextMenu(for: task)
							} preview: { DetailView(task: task) }
						}
					}
				}
			} header: {
				Text("pending.sections.upcoming").bold().foregroundColor(.mint)
			}
		}
	}
	
	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		markAsButtons(for: task)

		Button { selectedTask = task } label: {
			Label {
				Text("contextMenu.task.edit")
			} icon: { SFSymbols.pencilSquare }
		}
		
		Menu {
			Button(role: .cancel) {} label: {
				Label { Text("contextMenu.cancel") } icon: { SFSymbols.xmark }
			}
			Button(role: .destructive) {
				// Delete task here
			} label: {
				Label { Text("contextMenu.task.delete") } icon: { SFSymbols.trash }
			}
		} label: {
			Label { Text("contextMenu.task.delete") } icon: { SFSymbols.trash }
		}
	}

	@ViewBuilder
	private func markAsButtons(for task: TaskItem) -> some View {
		switch task.status {
		case .new:
			Section {
				Button {
					// mark task as in progress here
				} label: {
					Label {
						Text("contextMenu.task.markInProgress")
					} icon: { SFSymbols.circleArrows }
				}
				Button {
					// mark task as done here
					if isConfettiEnabled { confettiCounter += 1}
				} label: {
					Label {
						Text("contextMenu.task.markDone")
					} icon: { SFSymbols.checkmark }
				}
			} header: {
				Text("contextMenu.task.markAs")
			}
		case .inProgress:
			Section {
				Button {
					// mark task as new here
				} label: {
					Label {
						Text("contextMenu.task.markNew")
					} icon: { SFSymbols.sparkles }
				}
				Button {
					// mark task as done here
					if isConfettiEnabled { confettiCounter += 1}
				} label: {
					Label {
						Text("contextMenu.task.markDone")
					} icon: { SFSymbols.checkmark }
				}
			} header: {
				Text("contextMenu.task.markAs")
			}
		case .done: EmptyView()	// shouldn't happen in Pending view
		}
	}
	
	private var addTaskButton: some View {
		Button {
			isShowingAddTaskView.toggle()
		} label: {
			Label { Text("label.task.add") } icon: { SFSymbols.plus }
		}
	}
}

struct PendingView_Previews: PreviewProvider {
	static var previews: some View {
		PendingView()
	}
}
