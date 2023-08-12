//
//  HomeListCell.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-02-17.
//  Student ID: 101307949
//

import SwiftUI

struct HomeListCell: View {
	@ObservedObject var task: TaskItem
	@Preference(\.isRelativeDateTime) private var isRelativeDateTime
	@Preference(\.isTodayDuesHighlighted) private var isCellHighlighted
	@Environment(\.dynamicTypeSize) private var dynamicTypeSize

	private let columns = [
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible(), alignment: .leading)
	]

	var body: some View {
        let lowerLayout = decideOutmostLowerLayout()

        let nestedLowerFirstHalfLayout = dynamicTypeSize <= .accessibility1 ?
        AnyLayout(HStackLayout(alignment: .center)) :
        AnyLayout(VStackLayout(alignment: .leading))

		VStack(alignment: .leading) {
			HStack(alignment: .top) {
				if task.priority != .none { taskPriority }
				taskName
			}
			.bold(task.isNotDone ? true : false)

			lowerLayout {
                nestedLowerFirstHalfLayout {
                    taskStatus.padding(.trailing, 12)
                    taskDueDate.padding(.trailing, 12)
                }
				taskType
			}
		}
		.strikethrough(task.isNotDone ? false : true)
		.disableDefaultAccessibilityBehavior()
		.accessibilityElement(children: .combine)
		.accessibilityValue(accessibilityString)
	}
}

extension HomeListCell {
	private var taskStatus: some View {
		Label {
			Text(LocalizedStringKey(task.status.rawValue))
		} icon: {
			ZStack {
				switch task.status {
				case .new: SFSymbols.sparkles
				case .inProgress: SFSymbols.circleArrows
				case .done: SFSymbols.checkmark
				}
			}.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.if(task.isNotDone) { dueDate in
			dueDate.if(isCellHighlighted) { status in
				// intentional accessibility decision
				status.foregroundColor(.primary)
			} elseCase: { status in
				status.foregroundColor(task.colorForStatus())
			}
		} elseCase: { status in
			status.foregroundColor(.secondary)
		}
	}

	private var taskPriority: some View {
		DynamicColorLabel {
			Label {
				Text(LocalizedStringKey(task.priority.rawValue))
			} icon: {
				ZStack {
					switch task.priority {
					case .none: EmptyView()
					default: Text(task.priority.visualized)
					}
				}
			}
			.labelStyle(.iconOnly)
		}
		.font(.body)
		.foregroundColor(task.isNotDone ? nil : .secondary)
	}

	private var taskName: some View {
		Text(task.name)
			.font(.body)
			.foregroundColor(task.isNotDone ? .primary : .secondary)
			.lineLimit(2).truncationMode(.tail)
	}

	private var taskType: some View {
		Label {
			Text(LocalizedStringKey(task.type.rawValue))
		} icon: {
			ZStack {
				switch task.type {
				case .personal: SFSymbols.personFilled
				case .work: SFSymbols.buildingFilled
				case .school: SFSymbols.graduationCapFilled
				case .coding: SFSymbols.computer
				default: SFSymbols.listFilled
				}
			}.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.foregroundColor(task.isNotDone ? .primary : .secondary)
	}

	private var taskDueDate: some View {
		Label {
			Text(isRelativeDateTime ? task.relativeDueDate : task.shortDueDate)
		} icon: {
			SFSymbols.alarm.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.if(task.isNotDone) { dueDate in
			dueDate.if(isCellHighlighted) { dueDate in
				// intentional accessibility decision
				dueDate.foregroundColor(.primary)
			} elseCase: { dueDate in
				dueDate.foregroundColor(task.colorForDueDate())
			}
		} elseCase: { dueDate in
			dueDate.foregroundColor(.secondary)
		}
	}
}

extension HomeListCell {
	private func decideOutmostLowerLayout() -> AnyLayout {
		var layout: AnyLayout
		let preferredHorizontalLayout = AnyLayout(HStackLayout(alignment: .center))
		let preferredVerticalLayout = AnyLayout(VStackLayout(alignment: .leading))

		// When font size is larger than 120%
		if dynamicTypeSize > .xxLarge {
			layout = preferredVerticalLayout
		} else {
			layout = preferredHorizontalLayout
		}

		// When font size is larger than 100%, user turned on "Relative date time" mode, and task is in progress
		if dynamicTypeSize > .large && isRelativeDateTime && task.status == .inProgress {
			layout = preferredVerticalLayout
		} else {
			layout = preferredHorizontalLayout
		}

		return layout
	}

	private var accessibilityString: String {
		var string = ""
		string.append("Task name: \(task.name),")
		string.append("\(task.priority.accessibilityString) priority,")
		string.append("\(task.status.accessibilityString) status,")
		string.append(isRelativeDateTime ? "Due \(task.relativeDueDate)," : "Due on \(task.shortDueDate),")
		string.append("\(task.type.accessibilityString) type.")
		return string
	}
}

struct HomeListCell_Previews: PreviewProvider {
	static var previews: some View {
		HomeListCell(task: dev.task)
	}
}
