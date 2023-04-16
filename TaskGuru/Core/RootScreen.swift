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

	@EnvironmentObject private var homeVM: HomeViewModel
	@SceneStorage("selected-tab") private var selectedTab: Tab = .home
	@State var pendingTasksCount: Int = 0

	var body: some View {
		TabView(selection: .init(get: {
			selectedTab
		}, set: { newTab in
			haptic(.tabSelection)
			selectedTab = newTab
		})) {
			HomeScreen()
				.tag(Tab.home)
				.tabItem {
					SFSymbols.bulletList
					if isTabNamesEnabled { Text("home.tab.title") }
				}
			PendingScreen()
				.tag(Tab.pending)
				.tabItem {
					SFSymbols.clock
					if isTabNamesEnabled { Text("pending.tab.title") }
				}
				.badge(isShowingTabBadge ? pendingTasksCount : 0)
			SettingsScreen()
				.tag(Tab.settings)
				.tabItem {
					SFSymbols.gear
					if isTabNamesEnabled { Text("settings.tab.title") }
				}
		}
		.onReceive(homeVM.$isFetchingData) { _ in
			pendingTasksCount = homeVM.pendingTasks.count
		}
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootScreen()
	}
}
