//
//  TaskGuruApp.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-27.
//

import SwiftUI

@main
struct TaskGuruApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool = true
	@AppStorage(UserDefaultsKey.isShowingTabBadge) private var isShowingTabBadge: Bool?
	@AppStorage(UserDefaultsKey.isLockedInPortrait) private var isLockedInPortrait: Bool?
	
	private var appState: AppState = .init()
	@State private var pendingTasksCount: Int = 0
	
	var body: some Scene {
		WindowGroup {
			if isOnboarding {
				OnboardingContainerView()
					.transition(.asymmetric(insertion: .opacity.animation(.default), removal: .opacity))
			} else {
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
					(isLockedInPortrait ?? false) ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
				}
				.onChange(of: isLockedInPortrait) { _ in
					(isLockedInPortrait ?? false) ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
				}
				.environmentObject(appState)
			}
		}
	}
}
