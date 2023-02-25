//
//  ContentView.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-02-17.
//  Student ID: 101307949
//

import SwiftUI

struct HomeView: View {
	
	// These are state properties
	// for example in React: React.useState({object})
	@State private var isShowingAddTask: Bool = false
	@State private var selectedTask: TaskItem?
	
	@State private var searchText: String = ""
	
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@State private var confettiCounter: Int = 0

	// This is more of a computed property that gets update anytime
	// the view rerender. Like useEffect() in react.
	var noPendingTasksLeft: Bool {
		TaskItem.mockData.filter{ $0.isNotDone }.isEmpty
	}
	
	var body: some View {
		// new swift API from ios 16
		NavigationStack {
			List {
				overdueSection
				dueTodaySection
				upcomingSection
			}
			.playConfetti($confettiCounter)
			// pass the navigation value (TaskItem.self). This
			// may allow to have the component reusable
			.navigationDestination(for: TaskItem.self) { taskItem in
				DetailView(task: taskItem)
			}
			// inline allow us to have a small navigation title in the bar
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				// set the tile to the leading position on the nav bar
				// like padding start, right, left
				ToolbarItem(placement: .principal) {
					NavigationTitle(text: "All Tasks")
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					addTaskButton
				}
			}
			.searchable(text: $searchText)
			// this modifier will present itself once the state var is swapped
			// to true
			// equivalent to "show as modal" segue
			.sheet(isPresented: $isShowingAddTask) {
				AddTask()
			}
			.fullScreenCover(item: $selectedTask) { _ in
				EditView()
			}
		}
	}
}

// let us wrap up the components in this extension
extension HomeView {
	// Making the overdueSection nested view (reusable)
	private var overdueSection: some View {
		Section {
			// loop over the mockData array to show some tasks
			// $0 is essentially a shorthand for unnamed taskItem
			ForEach(TaskItem.mockData.filter { $0.dueDate.isPastToday }) { task in
				NavigationLink(value: task) {
					// HomeListCell (check file) is a reusable view and is being
					// passed a task
					HomeListCell(task: task)
				}
				// long press allows the view to be shown as popup, just previewing it. This one shows the contex menu, like edit and delete
				.contextMenu {
					makeContextMenu(for: task)
					// preview the task item as a popup
					// reuse the DetailView (Ostap)
				} preview: { DetailView(task: task) }
			}
			// it makes the header
		} header: {
			Text("Overdue")
				.bold()
				.foregroundColor(.red)
		}
	}
	
	private var dueTodaySection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.dueDate.isWithinToday }) { task in
				NavigationLink(value: task) {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(task: task) }
			}
		} header: {
			Text("Due Today")
				.bold()
				.foregroundColor(.orange)
		}
	}
	
	private var upcomingSection: some View {
		Section {
			ForEach(TaskItem.mockData.filter { $0.dueDate.isFromTomorrow }) { task in
				NavigationLink(value: task) {
					HomeListCell(task: task)
				}
				.contextMenu {
					makeContextMenu(for: task)
				} preview: { DetailView(task: task) }
			}
		} header: {
			Text("Upcoming")
				.bold()
				.foregroundColor(.mint)
		}
	}
	
	// Long press to show context menu
	@ViewBuilder
	private func makeContextMenu(for task: TaskItem) -> some View {
		// check if task is done or not
		if task.isNotDone {
			Button {
				// mark task as done here...
				if isConfettiEnabled { confettiCounter += 1 }
			} label: {
				Label { Text("Mark as Done") } icon: { SFSymbols.checkmark }
			}
		}
		// This always must be executed regardless the state of the task
		Button { selectedTask = task } label: {
			Label { Text("Edit") } icon: { SFSymbols.pencilSquare }
		}
		// make a line visible to distinguish the destructive action of delete below
		Divider()
		
		// a menu for the user to decide if they want to confirm delete or not
		Menu {
			Button(role: .cancel) {} label: {
				Label { Text("Cancel") } icon: { SFSymbols.xmark }
			}
			Button(role: .destructive) {
				// delete task here...
			} label: {
				Label { Text("Delete") } icon: { SFSymbols.trash }
			}
		} label: {
			Label { Text("Delete") } icon: { SFSymbols.trash }
		}
	}

	// Because we have usually used UIKit/Storyboard this is  similar to
	// IBAction func addTaskButtonTapped(), but in swift UI it is done by the following
	private var addTaskButton: some View {
		Button {
			// toogle set to true isShowingAddTask
			isShowingAddTask.toggle()
		} label: {
			// even though it is a Label, this represent a button.
			// icon: the icon we want to use
			// Text: will help people with screen readers to have it spelled
			Label { Text("Add Task") } icon: { SFSymbols.plus }
		}
	}
}

// Show on Xcode the live preview (from Xcode 14) or preview (Xcode 13 and earlier)
struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
