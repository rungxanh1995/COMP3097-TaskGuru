//
//  TaskGuruApp.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-27.
//

import UIKit
import SwiftUI

@main
struct TaskGuruApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@Environment(\.scenePhase) private var scenePhase

	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool = true
	@Preference(\.accentColor) private var accentColor
	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait
	@Preference(\.isTabNamesEnabled) private var isTabNamesEnabled

	@State private var pendingTasksCount: Int = 0

	init() {
		setAlertColor()
		if isLockedInPortrait { appDelegate.lockInPortraitMode() } else { appDelegate.unlockPortraitMode() }
	}

	var body: some Scene {
		WindowGroup {
			if isOnboarding {
				OnboardContainerView()
					.transition(.asymmetric(insertion: .opacity.animation(.default), removal: .opacity))
					.setUpColorTheme()
					.setUpFontDesign()
					.setUpAccentColor()
			} else {
				TabView {
					HomeView()
						.tabItem {
							SFSymbols.house
							if isTabNamesEnabled { Text("Home") }
						}
					PendingView()
						.tabItem {
							SFSymbols.clock
							if isTabNamesEnabled { Text("Pending") }
						}
						.badge(isShowingTabBadge ? pendingTasksCount : 0)
					SettingsView()
						.tabItem {
							SFSymbols.gear
							if isTabNamesEnabled { Text("Settings") }
						}
				}
				.onAppear {
					pendingTasksCount = TaskItem.mockData.filter{ $0.isNotDone }.count
					isLockedInPortrait ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
				}
				.onChange(of: accentColor) { _ in
					setAlertColor()
				}
				.onChange(of: isLockedInPortrait) { _ in
					isLockedInPortrait ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
				}
				.onChange(of: isShowingAppBadge) { _ in
					setAppBadgeOfPendingTasks()
				}
				.onChange(of: scenePhase) { newPhase in
					switch newPhase {
					case .background:
						addHomeScreenQuickActions()
						HomeQuickAction.selectedAction = nil
					case .active:
						handleQuickActionSelected()
					default:
						break
					}
				}
				.transition(.asymmetric(insertion: .opacity.animation(.default), removal: .opacity))
				.setUpFontDesign()
				.setUpAccentColor()
				.setUpColorTheme()
			}
		}
	}
}

extension TaskGuruApp {
	/// Fixes a SwiftUI default behavior, that a custom accent color is not accounted for in alerts.
	private func setAlertColor() {
		UIView.appearance(for: UITraitCollection(userInterfaceStyle: .light),
											whenContainedInInstancesOf: [UIAlertController.self])
		.tintColor = UIColor(Color.defaultAccentColor)

		UIView.appearance(for: UITraitCollection(userInterfaceStyle: .dark),
											whenContainedInInstancesOf: [UIAlertController.self])
		.tintColor = UIColor(Color.defaultAccentColor)
	}
	
	private func addHomeScreenQuickActions() {
		UIApplication.shared.shortcutItems = HomeQuickAction.allShortcutItems
	}
	
	private func handleQuickActionSelected() {
		guard let selectedAction = HomeQuickAction.selectedAction,
					let userInfo = selectedAction.userInfo,
					let actionName = userInfo["name"] as? String else { return }

		defer {
			// This is a bugfix to "add task" popping up when app is not in foreground,
			// i.e. when user enters system multitasking screen, then comes back to app.
			var newUserInfo = userInfo
			newUserInfo["name"] = HomeQuickAction.UserInfoType.allTasks.rawValue as any NSSecureCoding
			let updatedAction = UIApplicationShortcutItem(
				type: selectedAction.type, localizedTitle: selectedAction.localizedTitle, localizedSubtitle: nil,
				icon: selectedAction.icon, userInfo: newUserInfo)
			HomeQuickAction.selectedAction = updatedAction
		}

		switch actionName {
		case HomeQuickAction.UserInfoType.addTask.rawValue:
			// flip isShowingAddTaskView of HomeViewModel to true
			break
		default:
			// flip isShowingAddTaskView of HomeViewModel back to false
			break
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
						case true:	UIApplication.shared.applicationIconBadgeNumber = TaskItem.mockData.filter{ $0.isNotDone }.count
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
