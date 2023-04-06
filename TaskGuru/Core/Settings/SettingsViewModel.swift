//
//  SettingsViewModel.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-18.
//	Student ID: 101276573
//

import SwiftUI

extension SettingsScreen {
	final class ViewModel: ObservableObject {
		@Published var isConfirmingResetSettings: Bool = false
		@Published var isConfirmingResetUserData: Bool = false
		
		var appVersionNumber: String {
			Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
		}
		
		var appBuildNumber: String {
			Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
		}
		
		let joeGitHubLink: URL = URL(string: "https://github.com/rungxanh1995")!
		let marcoGitHubLink: URL = URL(string: "https://github.com/floydcoder")!
		let ostapGitHubLink: URL = URL(string: "https://github.com/ostap-sulyk")!
		let raufGitHubLink: URL = URL(string: "https://github.com/drrauf")!
		
		func resetDefaults() {
			let defaults = UserDefaults.standard
			let dictionary = defaults.dictionaryRepresentation()
			dictionary.keys.forEach { defaults.removeObject(forKey: $0) }
		}
		
		func resetAllTasks() {
			print("To implement in final implementation stage")
		}
	}
}
