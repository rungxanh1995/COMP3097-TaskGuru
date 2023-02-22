//
//  SettingsView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//	Student ID: 101276573
//

import SwiftUI

struct SettingsView: View {
	@StateObject private var vm: ViewModel
	@State private var isShowingOnboarding: Bool = false

	@Preference(\.isShowingAppBadge) private var isShowingAppBadge
	@Preference(\.isShowingTabBadge) private var isShowingTabBadge
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	@Preference(\.isLockedInPortrait) private var isLockedInPortrait
	@Preference(\.isHapticsReduced) private var isHapticsReduced
	@Preference(\.isTabNamesEnabled) private var isTabNamesEnabled
	@Preference(\.activeAppIcon) private var activeAppIcon
	@Preference(\.accentColor) private var accentColor
	@Preference(\.fontDesign) private var fontDesign
	@Preference(\.systemTheme) private var systemTheme
	@Preference(\.badgeType) private var badgeType
	@Preference(\.contextPreviewType) private var previewType

	init(vm: SettingsView.ViewModel = .init()) {
		_vm = StateObject(wrappedValue: vm)
	}

	var body: some View {
		NavigationView {
			Form {
				generalSection
				badgeSection
				miscSection
				advancedSection
				devTeamSection
				acknowledgments
				appNameAndLogo.listRowBackground(Color.clear)
			}
			.navigationBarTitleDisplayMode(.inline)
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
				isPresented: $vm.isConfirmingResetSettings,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {
					vm.resetDefaults()
					haptic(.success)
				}
				Button("Cancel", role: .cancel) { }
			}
			.confirmationDialog(
				"All your tasks would be deleted.\nThis action cannot be undone",
				isPresented: $vm.isConfirmingResetUserData,
				titleVisibility: .visible
			) {
				Button("Delete", role: .destructive) {
					vm.resetAllTasks()
					haptic(.success)
				}
				Button("Cancel", role: .cancel) { }
			}
			.onChange(of: activeAppIcon) { iconValue in
				updateAppIcon(from: iconValue)
			}
		}
		.navigationViewStyle(.stack)
	}
}

private extension SettingsView {
	private func updateAppIcon(from iconValue: Int) {
		let iconName = AppIconType(rawValue: iconValue)?.assetName
		UIApplication.shared.setAlternateIconName(iconName)
		haptic(.success)
	}
}

private extension SettingsView {
	private var generalSection: some View {
		Section {
			onboarding
			appIcon
			appAccentColor
			portraitLock
			haptics
			fontDesignStyle
			appTheme
		} header: {
			Label { Text("General") } icon: { SFSymbols.gearFilled }
		}
	}

	private var appIcon: some View {
		Picker("App Icon", selection: $activeAppIcon) {
			ForEach(AppIconType.allCases) { (appIcon) in
				Label {
					// TODO: Replace appIcon.assetName w/ appIcon.title
					// when localization has been added
					Text(LocalizedStringKey(appIcon.assetName))
				} icon: {
					appIcon.iconImage.asIconSize()
				}
				.labelStyle(.titleAndIcon)
				.tag(appIcon.rawValue)
			}
		}
		.pickerStyle(.navigationLink)
	}

	private var appAccentColor: some View {
		Picker("Accent Color", selection: $accentColor) {
			ForEach(AccentColorType.allCases) { (accent) in
				Label {
					Text(LocalizedStringKey(accent.title))
				} icon: {
					SFSymbols.circleFilled
						.foregroundColor(accent.inbuiltColor)
				}
				.labelStyle(.titleAndIcon)
				.tag(accent.rawValue)
			}
		}
		.pickerStyle(.navigationLink)
	}

	private var portraitLock: some View {
		Toggle("Portrait Lock", isOn: $isLockedInPortrait)
			.tint(.accentColor)
	}

	private var haptics: some View {
		Toggle("Reduce Haptics", isOn: $isHapticsReduced)
			.tint(.accentColor)
	}

	private var fontDesignStyle: some View {
		Picker("Font Style", selection: $fontDesign) {
			ForEach(FontDesignType.allCases) { (design) in
				Text(LocalizedStringKey(design.title))
					.tag(design.rawValue)
			}
		}
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
			appBadgeType
			tabBadge
		} header: {
			Label { Text("Badge") } icon: { SFSymbols.appBadge }
		} footer: {
			Text("Icon badge shows a number of tasks on Home screen. Review your Notification settings if no badge shown.")
		}
	}

	private var appBadge: some View {
		Toggle("Show App Icon Badge", isOn: $isShowingAppBadge)
			.tint(.accentColor)
	}

	private var appBadgeType: some View {
		Picker("App Icon Badge Type", selection: $badgeType) {
			ForEach(BadgeType.allCases) { (type) in
				Text(LocalizedStringKey(type.title))
					.tag(type.rawValue)
			}
		}
		.disabled(!isShowingAppBadge)
	}

	private var tabBadge: some View {
		Toggle("Show Tab Badge", isOn: $isShowingTabBadge)
			.tint(.accentColor)
	}

	private var miscSection: some View {
		Section {
			tabNames
			confetti
			preview
			contextPreviewType
		} header: {
			Label { Text("Miscellaneous") } icon: { SFSymbols.bubbleSparkles }
		} footer: {
			Text("Long pressing a task from a list reveals a context menu for the task when enabled.")
		}
	}

	private var tabNames: some View {
		Toggle("Tab Names", isOn: $isTabNamesEnabled)
			.tint(.accentColor)
	}

	private var confetti: some View {
		Toggle("Toggle Confetti 🎉", isOn: $isConfettiEnabled)
			.tint(.accentColor)
	}

	private var preview: some View {
		Toggle("Preview on Haptic Touch", isOn: $isPreviewEnabled)
			.tint(.accentColor)
	}

	private var contextPreviewType: some View {
		Picker("Preview Type on Haptic Touch", selection: $previewType) {
			ForEach(ContextPreviewType.allCases) { (type) in
				Text(LocalizedStringKey(type.title))
					.tag(type.rawValue)
			}
		}
		.pickerStyle(.segmented)
		.disabled(!isPreviewEnabled)
	}

	private var advancedSection: some View {
		Section {
			resetAppSettingsButton
			resetAppDataButton
		} header: {
			Label { Text("Advanced") } icon: { SFSymbols.magicWand }
		} footer: {
			Text("Be careful, these remove all your data! Restart the app to see all changes.")
		}
	}

	private var resetAppSettingsButton: some View {
		Button(role: .destructive) {
			vm.isConfirmingResetSettings.toggle()
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
			vm.isConfirmingResetUserData.toggle()
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
			Label { Text("Meet The Team") } icon: { SFSymbols.handsSparklesFilled }
		}
	}

	private var acknowledgments: some View {
		Section {
			NavigationLink("Acknowledgments") {
				AcknowledgmentsView()
			}
		}
	}

	private var appNameAndLogo: some View {
		VStack(spacing: 8) {
			HStack {
				Spacer()
				Text("TaskGuru \(vm.appVersionNumber) (\(vm.appBuildNumber))")
					.font(.system(.callout))
					.foregroundColor(.secondary)
				Spacer()
			}

			if let icon = AppIconType(rawValue: activeAppIcon)?.iconImage {
				icon.asIconSize()
			} else {
				Image("app-logo").asIconSize()
			}
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
