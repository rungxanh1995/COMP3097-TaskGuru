//
//  RootScreen.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-21.
//	Student ID: 101276573
//

import SwiftUI

enum Tab: Int, Hashable { case home, pending, settings }

struct RootScreen: View {
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isTabNamesEnabled) private var isTabNamesEnabled

	@State var pendingTasksCount: Int = 0

	var body: some View {
		TabView {
			HomeScreen()
				.tag(Tab.home)
				.tabItem {
					SFSymbols.bulletList
					if isTabNamesEnabled { Text("Home") }
				}
			PendingScreen()
				.tag(Tab.pending)
				.tabItem {
					SFSymbols.clock
					if isTabNamesEnabled { Text("Pending") }
				}
				.badge(isShowingTabBadge ? pendingTasksCount : 0)
			SettingsScreen()
				.tag(Tab.settings)
				.tabItem {
					SFSymbols.gear
					if isTabNamesEnabled { Text("Settings") }
				}
		}
		.onAppear {
			pendingTasksCount = TaskItem.mockData.filter{ $0.isNotDone }.count
		}
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootScreen()
	}
}
