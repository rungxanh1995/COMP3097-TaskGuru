//
//  SettingsView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//

import SwiftUI

struct SettingsView: View {
	
	private let colorThemes = ["System", "Light", "Dark"]
	@State private var selectedColorTheme = "System"
	
	@State private var isShowingOnboarding: Bool = false
	
	@AppStorage(UserDefaultsKey.isShowingTabBadge)
	private var isShowingTabBadge: Bool = true
	
	@AppStorage(UserDefaultsKey.isLockedInPortrait)
	private var isLockedInPortrait: Bool = false
	
	@AppStorage(UserDefaultsKey.hapticsReduced)
	private var isHapticReduced = false
	
	var appVersionNumber: String {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
	}
	
	var appBuildNumber: String {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
	}
	
	@State private var isConfirmingResetSettings = false
	@State private var isConfirmingResetUserData = false
	
	var body: some View {
		NavigationView {
			Form {
				generalSection
				devTeamSection
				advancedSection
			}
			.navigationTitle("Settings")
			.confirmationDialog(
				"App settings would reset.\nThis action cannot be undone",
				isPresented: $isConfirmingResetSettings,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {}
				Button("Cancel", role: .cancel) {}
			}
			.confirmationDialog(
				"All your tasks would be deleted.\nThis action cannot be undone",
				isPresented: $isConfirmingResetUserData,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {}
				Button("Cancel", role: .cancel) {}
			}
		}
	}
}

private extension SettingsView {
	private var generalSection: some View {
		Section {
			onboarding
			tabBadge
			portraitLock
			haptics
			appTheme
		} header: {
			HStack {
				SFSymbols.gearFilled
				Text("General")
			}
		} footer: {
			Text("App Version: \(appVersionNumber) (\(appBuildNumber))")
		}
	}
	
	private var onboarding: some View {
		Button {
			isShowingOnboarding.toggle()
		} label: {
			Text("Show Onboarding screen")
		}
	}
	
	private var tabBadge: some View {
		Toggle("Show Tab Badge", isOn: $isShowingTabBadge)
			.tint(.accentColor)
	}
	
	private var portraitLock: some View {
		Toggle("Portrait Lock", isOn: $isLockedInPortrait)
			.tint(.accentColor)
	}
	
	private var haptics: some View {
		Toggle("Reduce Haptics", isOn: $isHapticReduced)
			.tint(.accentColor)
	}
	
	private var appTheme: some View {
		Picker("Color Theme", selection: $selectedColorTheme) {
			ForEach(colorThemes, id: \.self) { (theme) in
				Text(theme)
					.tag(theme)
			}
		}
	}
	
	private var advancedSection: some View {
		Section {
			resetAppSettingsButton
			resetAppDataButton
		} header: {
			HStack {
				SFSymbols.magicWand
				Text("Advanced")
			}
		} footer: {
			Text("Be careful, this removes all your data! Restart the app to see all changes")
		}
	}
	
	private var resetAppSettingsButton: some View {
		Button(role: .destructive) {
			isConfirmingResetSettings.toggle()
		} label: {
			Label {
				Text("Reset App Settings")
			} icon: {
				SFSymbols.gear.foregroundColor(.red)
			}
		}
	}

	private var resetAppDataButton: some View {
		Button(role: .destructive) {
			isConfirmingResetUserData.toggle()
		} label: {
			Label {
				Text("Reset Your Data")
			} icon: {
				SFSymbols.personFolder.foregroundColor(.red)
			}
		}
	}

	private var devTeamSection: some View {
		Section {
			HStack {
				SFSymbols.link
				Link("Joe Pham", destination: URL(string: "https://twitter.com/rungxanh1995")!)
			}
			
			HStack {
				SFSymbols.link
				Link("Marco Stevanella", destination: URL(string: "https://github.com/floydcoder")!)
			}
			
			HStack {
				SFSymbols.link
				Link("Ostap Sulyk", destination: URL(string: "https://github.com/ostap-sulyk")!)
			}
			
			HStack {
				SFSymbols.link
				Link("Rauf Anata", destination: URL(string: "https://github.com/drrauf")!)
			}
		} header: {
			HStack {
				SFSymbols.handsSparklesFilled
				Text("Meet The Team")
			}
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
