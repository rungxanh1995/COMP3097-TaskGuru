//
//  TaskGuruApp.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

@main
struct TaskGuruApp: App {
	@AppStorage(UserDefaultsKey.isShowingTabBadge) private var isShowingTabBadge: Bool?
	
	private var appState: AppState = .init()
	@State private var pendingTasksCount: Int = 0
	
	var body: some Scene {
		WindowGroup {
			TabView {
				HomeView()
					.tabItem {
						SFSymbols.house
						Text("Home")
					}
				PendingView()
					.tabItem {
						SFSymbols.clock
						Text("Pending")
					}
					.badge((isShowingTabBadge ?? true) ? pendingTasksCount : 0)
				SettingsView()
					.tabItem {
						SFSymbols.gear
						Text("Settings")
					}
			}
			.onAppear {
				pendingTasksCount = TaskItem.mockData.filter { $0.isNotDone }.count
			}
			.environmentObject(appState)
		}
	}
}
