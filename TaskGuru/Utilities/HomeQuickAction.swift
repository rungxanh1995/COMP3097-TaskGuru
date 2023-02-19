//
//  HomeQuickAction.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-18.
//	Student ID: 101276573
//

import UIKit

enum HomeQuickAction {
	enum UserInfoType: String {
		case addTask, allTasks
	}
	
	static var selectedAction: UIApplicationShortcutItem?
	
	static var addTaskUserInfo: [String: NSSecureCoding] {
		["name": UserInfoType.addTask.rawValue as NSSecureCoding]
	}
	
	static var allTasksUserInfo: [String: NSSecureCoding] {
		["name": UserInfoType.allTasks.rawValue as NSSecureCoding]
	}
	
	static var allShortcutItems: [UIApplicationShortcutItem] = [
		.init(type: "addTask", localizedTitle: NSLocalizedString("Add Task", comment: ""),
					localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: addTaskUserInfo)
	]
}
