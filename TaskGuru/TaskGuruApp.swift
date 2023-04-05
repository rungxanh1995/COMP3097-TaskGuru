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

	@StateObject private var homeVM: HomeViewModel = .init()

	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool = true
	@Preference(\.accentColor) private var accentColor
	@Preference(\.badgeType) private var badgeType
	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait

	init() {
		setAlertColor()
		if isLockedInPortrait {
			appDelegate.lockInPortraitMode()
		} else {
			appDelegate.unlockPortraitMode()
		}
	}

	var body: some Scene {
		WindowGroup {
			RootScreen()
				.sheet(isPresented: .constant(isOnboarding)) {
					OnboardContainerView()
						.interactiveDismissDisabled()
				}
				.environmentObject(homeVM)
				.setUpColorTheme()
				.setUpFontDesign()
				.setUpFontWidth()
				.setUpBoldFont()
				.setUpAccentColor()
				.onChange(of: accentColor) { _ in
					setAlertColor()
				}
				.onChange(of: badgeType) { _ in
					setUpAppIconBadge()
				}
				.onChange(of: isShowingAppBadge) { _ in
					setUpAppIconBadge()
				}
				.onChange(of: isLockedInPortrait) { _ in
					isLockedInPortrait ? appDelegate.lockInPortraitMode() : appDelegate.unlockPortraitMode()
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
		}
	}
}

// MARK: Alert Color Theme + Home screen Quick Action
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

// MARK: App Badge on Home screen

import UserNotifications

extension TaskGuruApp {
	private func setUpAppIconBadge() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { success, error in
			if success {
				Task {
					await MainActor.run {
						switch isShowingAppBadge {
						case true:	UIApplication.shared.applicationIconBadgeNumber = badgeNumberForAppIcon()
						case false: UIApplication.shared.applicationIconBadgeNumber = 0
						}
					}
				}
			} else if let error = error {
				print(error.localizedDescription)
			}
		}
	}

	private func badgeNumberForAppIcon() -> Int {
		guard let badge = BadgeType(rawValue: badgeType) else { return 0 }
		// TODO: Update these cases when HomeViewModel is implemented.
		// No need to depend on mockData anymore.
		return 0
	}
}
