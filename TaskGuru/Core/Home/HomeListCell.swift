//
//  HomeListCell.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-02-17.
//  Student ID: 101307949
//

import SwiftUI

struct HomeListCell: View {
	
	// it is a variable task as a type TaskItem
	var task: TaskItem
	
	// The required body for the view
	var body: some View {
		// H Stack is an horizontal stack
		HStack(alignment: .top) {
			// VStack is a vertical stack, leading is on the left side
			VStack(alignment: .leading, spacing: 4) {
				taskName
				taskType
			}
			
			// a flexible padding spacer that uses the available space
			Spacer()
			
			// another vstack this time with trailing so that is displayed on the right
			VStack(alignment: .trailing, spacing: 4) {
				taskDueDate
				taskStatus
			}
		}
	}
}

extension HomeListCell {
	private var taskName: some View {
		// NAME
		Text(task.name)
		// to allow Dynamic Type support in the app
			.font(.system(.body))
	}
	
	// TYPE
	private var taskType: some View {
		HStack(spacing: 4) {
			// to be able to match which icon to use for the type let us use swtich case
			Group {
				switch task.type {
				case .personal: SFSymbols.personFilled
				case .work: SFSymbols.buildingFilled
				case .school: SFSymbols.graduationCapFilled
				case .coding: SFSymbols.computer
				default: SFSymbols.listFilled
				}
			}
			// decide the font size
			.font(.system(.caption2))
			
			// the actual string category
			Text(task.type.rawValue)
		}
		.font(.system(.subheadline))
		// secondary as faded gray
		.foregroundColor(.secondary)
	}
	
	private var taskDueDate: some View {
		HStack(spacing: 6) {
			SFSymbols.calendarWithClock.font(.callout)
			Text(task.shortDueDate)
		}
		.font(.system(.body))
		// check the colorForDueDate extension
		.foregroundColor(task.colorForDueDate())
	}
	
	private var taskStatus: some View {
		HStack(spacing: 4) {
			Group {
				switch task.status {
				case .new: SFSymbols.sparkles
				case .inProgress: SFSymbols.circleArrows
				case .done: SFSymbols.checkmark
				}
			}
			.font(.system(.caption2))
			
			Text(task.status.rawValue)
		}
		.font(.system(.subheadline))
		// check the colorForStatus extension
		.foregroundColor(task.colorForStatus())
	}
}

