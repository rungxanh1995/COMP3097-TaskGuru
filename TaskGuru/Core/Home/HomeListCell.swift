//
//  HomeListCell.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-02-17.
//  Student ID: 101307949
//

import SwiftUI

struct HomeListCell: View {
	
	var task: TaskItem
	@Preference(\.isRelativeDateTime) private var isRelativeDateTime
	@Environment(\.dynamicTypeSize) var dynamicTypeSize

	private let columns = [
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible(), alignment: .leading)
	]

	var body: some View {
		let lowerLayout = dynamicTypeSize <= .xxLarge ?
		AnyLayout(HStackLayout(alignment: .center)) :
		AnyLayout(VStackLayout(alignment: .leading))

		VStack(alignment: .leading) {
			HStack(alignment: .top) {
				taskName
			}
			.bold(task.isNotDone ? true : false)

			lowerLayout {
				taskStatus.padding(.trailing, 12)
				taskDueDate.padding(.trailing, 12)
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
		.foregroundStyle(task.colorForStatus())
	}

	private var taskName: some View {
		Text(task.name)
			.font(.body)
			.foregroundColor(task.isNotDone ? nil : .secondary)
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
		.foregroundColor(task.isNotDone ? nil : .secondary)
	}

	private var taskDueDate: some View {
		Label {
			Text(task.shortDueDate)
		} icon: {
			SFSymbols.alarm.font(.caption)
		}
		.labelStyle(.titleAndIcon)
		.font(.subheadline)
		.foregroundColor(task.isNotDone ? task.colorForDueDate() : .secondary)
	}
}

extension HomeListCell {
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
