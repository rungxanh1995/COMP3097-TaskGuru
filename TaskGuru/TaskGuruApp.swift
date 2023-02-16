//
//  TaskGuruApp.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-27.
//	Student ID: 101276573
//

import SwiftUI
import UIKit

@main
struct TaskGuruApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool = true
	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait
	
	@State private var pendingTasksCount: Int = 0
	
	var body: some Scene {
		WindowGroup {
			if isOnboarding {
				OnboardingContainerView()
					.transition(.asymmetric(insertion: .opacity.animation(.default), removal: .opacity))
					.setUpColorTheme()
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
						.badge(isShowingTabBadge ? pendingTasksCount : 0)
					SettingsView()
						.tabItem {
							SFSymbols.gear
							Text("Settings")
						}
				}
				.onAppear {
					pendingTasksCount = TaskItem.mockData.filter { $0.isNotDone }.count
					isLockedInPortrait ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
					if isShowingAppBadge { setAppBadgeOfPendingTasks() }
				}
				.onChange(of: isLockedInPortrait) { _ in
					isLockedInPortrait ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
				}
				.onChange(of: isShowingAppBadge) { _ in
					setAppBadgeOfPendingTasks()
				}
				.setUpColorTheme()
			}
		}
	}
}

import UserNotifications

extension TaskGuruApp {
	private func setAppBadgeOfPendingTasks() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { success, error in
			if success {
				Task {
					await MainActor.run {
						switch isShowingAppBadge {
						case true:	UIApplication.shared.applicationIconBadgeNumber = TaskItem.mockData.filter { $0.isNotDone }.count
						case false: UIApplication.shared.applicationIconBadgeNumber = 0
						}
					}
				}
			} else if let error = error {
				print(error.localizedDescription)
			}
		}
	}
}

