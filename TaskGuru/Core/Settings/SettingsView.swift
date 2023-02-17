//
//  SettingsView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//	Student ID: 101276573
//

import SwiftUI

struct SettingsView: View {
	@State private var isShowingOnboarding: Bool = false
	
	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait
	@Preference(\.isHapticsReduced) private var isHapticsReduced
	@Preference(\.systemTheme) private var systemTheme
	
	@State private var isConfirmingResetSettings: Bool = false
	@State private var isConfirmingResetUserData: Bool = false
	
	var appVersionNumber: String {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
	}
	
	var appBuildNumber: String {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
	}
	
	var body: some View {
		NavigationView {
			Form {
				generalSection
				badgeSection
				miscSection
				devTeamSection
				advancedSection
				
				appNameAndLogo
					.listRowBackground(Color.clear)
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					GradientNavigationTitle(text: "Settings")
				}
			}
			.sheet(isPresented: $isShowingOnboarding, content: {
				OnboardContainerView()
			})
			.confirmationDialog(
				"App settings would reset.\nThis action cannot be undone",
				isPresented: $isConfirmingResetSettings,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {
					// delete app settings here
					haptic(.success)
				}
				Button("Cancel", role: .cancel) { }
			}
			.confirmationDialog(
				"All your tasks would be deleted.\nThis action cannot be undone",
				isPresented: $isConfirmingResetUserData,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {
					// delete user data here
					haptic(.success)
				}
				Button("Cancel", role: .cancel) { }
			}
		}
		.navigationViewStyle(.stack)
	}
}

private extension SettingsView {
	private var generalSection: some View {
		Section {
			onboarding
			portraitLock
			haptics
			appTheme
		} header: {
			Label { Text("General") } icon: { SFSymbols.gearFilled }
		}
	}
	
	private var portraitLock: some View {
		Toggle("Portrait Lock", isOn: $isLockedInPortrait)
			.tint(.accentColor)
	}
	
	private var haptics: some View {
		Toggle("Reduce Haptics", isOn: $isHapticsReduced)
			.tint(.accentColor)
	}
	
	private var appTheme: some View {
		Picker("Color Theme", selection: $systemTheme) {
			ForEach(SchemeType.allCases) { (theme) in
				Text(LocalizedStringKey(theme.title))
					.tag(theme.rawValue)
			}
		}
	}
	
	private var onboarding: some View {
		Button {
			isShowingOnboarding.toggle()
		} label: {
			Text("Show Onboarding screen")
		}
	}
	
	private var badgeSection: some View {
		Section {
			appBadge
			tabBadge
		} header: {
			Label { Text("Badge") } icon: { SFSymbols.appBadge }
		} footer: {
			Text("Display a number of your pending tasks on Home screen. Review your Notification settings if no badge shown.")
		}
	}
	
	private var appBadge: some View {
		Toggle("Show App Icon Badge", isOn: $isShowingAppBadge)
			.tint(.accentColor)
	}
	
	private var tabBadge: some View {
		Toggle("Show Tab Badge", isOn: $isShowingTabBadge)
			.tint(.accentColor)
	}
	
	private var miscSection: some View {
		Section {
			confetti
			preview
		} header: {
			Label { Text("Miscellaneous") } icon: { SFSymbols.bubbleSparkles }
		} footer: {
			Text("Long pressing a task from a list reveals a detail preview of the task when enabled.")
		}
	}
	
	private var confetti: some View {
		Toggle("Toggle Confetti 🎉", isOn: $isConfettiEnabled)
			.tint(.accentColor)
	}
	
	private var preview: some View {
		Toggle("Preview on Haptic Touch", isOn: $isPreviewEnabled)
			.tint(.accentColor)
	}
	
	private var advancedSection: some View {
		Section {
			resetAppSettingsButton
			resetAppDataButton
		} header: {
			Label { Text("Advanced") } icon: { SFSymbols.magicWand }
		} footer: {
			Text("Be careful, these remove all your data! Restart the app to see all changes")
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
