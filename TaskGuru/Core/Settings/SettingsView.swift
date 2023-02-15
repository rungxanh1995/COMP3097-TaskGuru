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

				appNameAndLogo
					.listRowBackground(Color.clear)
			}
			.navigationTitle("Settings")
			.sheet(isPresented: $isShowingOnboarding) {
				OnboardingContainerView()
			}
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
			Label { Text("General") } icon: { SFSymbols.gearFilled }
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
				Text(theme).tag(theme)
			}
		}
	}
	
	private var advancedSection: some View {
		Section {
			resetAppSettingsButton
			resetAppDataButton
		} header: {
			Label { Text("Advanced") } icon: { SFSymbols.magicWand }
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
			Label {
				Link("Joe Pham", destination: URL(string: "https://github.com/rungxanh1995")!)
			} icon: { SFSymbols.link }

			Label {
				Link("Marco Stevanella", destination: URL(string: "https://github.com/floydcoder")!)
			} icon: { SFSymbols.link }

			Label {
				Link("Ostap Sulyk", destination: URL(string: "https://github.com/ostap-sulyk")!)
			} icon: { SFSymbols.link }

			Label {
				Link("Rauf Anata", destination: URL(string: "https://github.com/drrauf")!)
			} icon: { SFSymbols.link }
		} header: {
			Label { Text("Meet The Team") } icon: { SFSymbols.handsSparklesFilled }
		}
	}
	
	private var appNameAndLogo: some View {
		VStack(spacing: 8) {
			HStack {
				Spacer()
				Text("TaskGuru \(appVersionNumber) (\(appBuildNumber))")
					.font(.system(.callout))
					.foregroundColor(.secondary)
				Spacer()
			}
			
			Image("app-logo")
				.resizable()
				.scaledToFit()
				.frame(width: 44, height: 44)
				.clipShape(RoundedRectangle(cornerRadius: 10))
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
