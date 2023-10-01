//
//  SettingsScreen.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//	Student ID: 101276573
//

import SwiftUI

import SwiftUI

struct SettingsScreen: View {
	@StateObject private var vm: ViewModel
	
	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.badgeType) private var badgeType
	@Preference(\.isRelativeDateTime) private var isRelativeDateTime
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait
	@Preference(\.isHapticsReduced) private var isHapticsReduced
	@Preference(\.activeAppIcon) private var activeAppIcon
	
	init(vm: SettingsScreen.ViewModel = .init()) {
		_vm = StateObject(wrappedValue: vm)
	}
	
	var body: some View {
		NavigationStack {
			Form {
				generalSection
				dateTimeSection
				badgeSection
				displayLanguage
				advancedSection
				devTeamSection
				onboarding
				acknowledgements
				appNameAndLogo
					.listRowBackground(Color.clear)
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .principal) {
					NavigationTitle(text: "settings.nav.title")
				}
			}
			.confirmationDialog(
				"settings.advanced.resetSettings.alert",
				isPresented: $vm.isConfirmingResetSettings,
				titleVisibility: .visible
			) {
				Button("settings.advanced.resetSettings.delete", role: .destructive) {
					vm.resetDefaults()
					haptic(.notification(.success))
				}
				Button("settings.advanced.resetSettings.cancel", role: .cancel) { }
			}
			.confirmationDialog(
				"settings.advanced.resetUserData.alert",
				isPresented: $vm.isConfirmingResetUserData,
				titleVisibility: .visible
			) {
				Button("settings.advanced.resetUserData.delete", role: .destructive) {
					vm.resetAllTasks()
					haptic(.notification(.success))
				}
				Button("settings.advanced.resetUserData.cancel", role: .cancel) { }
			}
		}
		.navigationViewStyle(.stack)
	}
}

private extension SettingsScreen {
	private var generalSection: some View {
		Section {
			appearance
			portraitLock
			haptics
		} header: {
			Label {
				Text("settings.sections.general")
			} icon: { SFSymbols.gearFilled }
		}
	}
	
	private var appearance: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.paintbrush, accent: .appClover)
		} content: {
			NavigationLink {
				AppearanceScreen()
			} label: {
				Text("settings.general.appearance")
			}
		}
	}
	
	private var portraitLock: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.lockRotation, accent: .appIndigo)
		} content: {
			Toggle("settings.general.portraitLock", isOn: $isLockedInPortrait)
				.tint(.accentColor)
		}
	}
	
	private var haptics: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.waveform, accent: .appYellow)
		} content: {
			Toggle("settings.general.reduceHaptics", isOn: $isHapticsReduced)
				.tint(.accentColor)
		}
	}
	
	private var dateTimeSection: some View {
		Section {
			relativeDateTime
		} footer: {
			Text("settings.general.relDateTime.footer")
		}
	}
	
	private var relativeDateTime: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.clock, accent: .appGreen)
		} content: {
			Toggle("settings.general.relDateTime", isOn: $isRelativeDateTime)
				.tint(.accentColor)
		}
	}
	
	private var badgeSection: some View {
		Section {
			tabBadge
			appBadge
			notifSettingLink
		} header: {
			Label { Text("settings.sections.badge") } icon: { SFSymbols.appBadge }
		} footer: {
			Text("settings.badge.footer")
		}
	}
	
	private var tabBadge: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.clockBadge, accent: .appPink)
		} content: {
			Toggle("settings.badge.tab", isOn: $isShowingTabBadge)
				.tint(.accentColor)
		}
	}
	
	private var appBadge: some View {
		VStack {
			settingsRow {
				SettingsIcon(icon: SFSymbols.appBadge, accent: .appPurple)
			} content: {
				Toggle("settings.badge.appIcon", isOn: $isShowingAppBadge)
					.tint(.accentColor)
			}
			Picker("settings.badge.appIconType", selection: $badgeType) {
				ForEach(BadgeType.allCases) { (type) in
					Text(LocalizedStringKey(type.title))
						.tag(type.rawValue)
				}
			}
			.disabled(!isShowingAppBadge)
		}
	}
	
	/// Guide user to System notification settings to manually allow permission for badge
	private var notifSettingLink: some View {
		HStack {
			let url = URL(string: UIApplication.openNotificationSettingsURLString)!
			Link("settings.badge.notifSetting", destination: url)
				.tint(.primary)
			Spacer()
			SFSymbols.arrowUpForward
				.foregroundStyle(isShowingAppBadge ? .primary : Color.gray.opacity(0.5))
		}
		.disabled(!isShowingAppBadge)
	}
	
	private var displayLanguage: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.globe, accent: .appOrange)
		} content: {
			let url = URL(string: UIApplication.openSettingsURLString)!
			Link("settings.misc.language", destination: url)
				.tint(.primary)
			Spacer()
			SFSymbols.arrowUpForward
		}
	}
	
	private var advancedSection: some View {
		Section {
			resetAppSettingsButton
			resetAppDataButton
		} header: {
			Label { Text("settings.sections.advanced") } icon: { SFSymbols.magicWand }
		} footer: {
			Text("settings.advanced.footer")
		}
	}
	
	private var resetAppSettingsButton: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.gear, accent: .red)
		} content: {
			Button(role: .destructive) {
				vm.isConfirmingResetSettings.toggle()
			} label: {
				Text("settings.advanced.resetSettings")
			}
		}
	}
	
	private var resetAppDataButton: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.personFolder, accent: .red)
		} content: {
			Button(role: .destructive) {
				vm.isConfirmingResetUserData.toggle()
			} label: {
				Text("settings.advanced.resetUserData")
			}
		}
	}
	
	private var devTeamSection: some View {
		Section {
			Label {
				Link("Joe Pham", destination: vm.joeGitHubLink)
			} icon: { SFSymbols.link }
			
			Label {
				Link("Marco Stevanella", destination: vm.marcoGitHubLink)
			} icon: { SFSymbols.link }
			
			Label {
				Link("Ostap Sulyk", destination: vm.ostapGitHubLink)
			} icon: { SFSymbols.link }
			
			Label {
				Link("Rauf Anata", destination: vm.raufGitHubLink)
			} icon: { SFSymbols.link }
		} header: {
			Label { Text("settings.sections.devTeam") } icon: { SFSymbols.handsSparklesFilled }
		}
	}
	
	private var onboarding: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.handWave, accent: .defaultAccentColor)
		} content: {
			NavigationLink("settings.general.onboarding") {
				OnboardContainerView()
			}
		}
	}
	
	private var acknowledgements: some View {
		Section {
			NavigationLink("settings.sections.ack") {
				AcknowledgmentsView()
			}
		}
	}
	
	private var appNameAndLogo: some View {
		VStack(spacing: 8) {
			HStack {
				Spacer()
				Text("TaskGuru \(vm.appVersionNumber) (\(vm.appBuildNumber))")
					.font(.callout)
					.foregroundStyle(.secondary)
				Spacer()
			}
			
			if let icon = AppIconType(rawValue: activeAppIcon)?.iconImage {
				icon.asIcon()
			} else {
				Image("app-logo").asIcon()
			}
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsScreen()
	}
}
