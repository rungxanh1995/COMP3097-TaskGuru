//
//  Preferences.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-15.
//	Student ID: 101276573
//
//	Link: https://www.avanderlee.com/swift/appstorage-explained/
//

import Combine
import Foundation

/// Initializes and hosts all settings specific to the app
final class Preferences {
	static let standard = Preferences(userDefaults: .standard)
	internal let userDefaults: UserDefaults
	
	/// Sends through the changed keypath whenever a change occurs
	var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
	
	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}
	
	// INITIALIZE APP PREFERENCES HERE
	@UserDefault(UserDefaultsKey.iShowingAppBadge)
	var isShowingAppBadge: Bool = false
	
	@UserDefault(UserDefaultsKey.isShowingTabBadge)
	var isShowingTabBadge: Bool = true
	
	@UserDefault(UserDefaultsKey.isPreviewEnabled)
	var isPreviewEnabled: Bool = true
	
	@UserDefault(UserDefaultsKey.isLockedInPortrait)
	var isLockedInPortrait: Bool = false
	
	@UserDefault(UserDefaultsKey.hapticsReduced)
	var isHapticsReduced: Bool = false
	
	@UserDefault(UserDefaultsKey.systemTheme)
	var systemTheme: Int = SchemeType.allCases.first!.rawValue
}
