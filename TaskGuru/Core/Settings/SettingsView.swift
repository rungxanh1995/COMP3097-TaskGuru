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
	@Preference(\.contextPreviewType) private var contextPreviewType

	init(vm: SettingsView.ViewModel = .init()) {
		_vm = StateObject(wrappedValue: vm)
	}

	var body: some View {
		NavigationStack {
			Form {
				generalSection
				badgeSection
				miscSection
				advancedSection
				devTeamSection
				acknowledgements
				appNameAndLogo.listRowBackground(Color.clear)
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .principal) {
					NavigationTitle(text: "settings.nav.title")
				}
			}
			.sheet(isPresented: $isShowingOnboarding) {
				OnboardContainerView()
			}
			.confirmationDialog(
				"settings.advanced.resetSettings.alert",
				isPresented: $vm.isConfirmingResetSettings,
				titleVisibility: .visible
			) {
				Button("settings.advanced.resetSettings.delete", role: .destructive) {
					vm.resetDefaults()
					haptic(.success)
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
					haptic(.success)
				}
				Button("settings.advanced.resetUserData.cancel", role: .cancel) { }
			}
		}
		.navigationViewStyle(.stack)
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
			Label {
				Text("settings.sections.general")
			} icon: { SFSymbols.gearFilled }
		}
	}

	@ViewBuilder private var appIcon: some View {
		let currentIcon = AppIconType(rawValue: activeAppIcon)

		HStack {
			if let icon = AppIconType(rawValue: activeAppIcon)?.iconImage {
				icon.asSettingsIconSize()
			} else {
				Image("app-logo").asSettingsIconSize()
			}
			NavigationLink {
				AppIconSettings()
			} label: {
				Text("settings.general.appIcon")
					.ifLet(currentIcon?.title, content: { text, iconName in
						text.badge(LocalizedStringKey(iconName))
					})
			}
		}
	}

	private var portraitLock: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.lockRotation, bgColor: .indigo)
			Toggle("settings.general.portraitLock", isOn: $isLockedInPortrait)
				.tint(.accentColor)
		}
	}

	private var haptics: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.waveform, bgColor: .pink)
			Toggle("settings.general.reduceHaptics", isOn: $isHapticsReduced)
				.tint(.accentColor)
		}
	}

	@ViewBuilder private var appAccentColor: some View {
		let currentAccentColor = AccentColorType(rawValue: accentColor)
		HStack {
			SettingsIcon(icon: SFSymbols.paintbrush, bgColor: .defaultAccentColor)
			NavigationLink {
				AccentColorSettings()
			} label: {
				Text("settings.general.accentColor")
					.ifLet(currentAccentColor?.title) { text, colorName in
						text.badge(LocalizedStringKey(colorName))
					}
			}
		}
	}

	private var fontDesignStyle: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.textFormat, bgColor: .orange)
			Picker("settings.general.fontStyle", selection: $fontDesign) {
				ForEach(FontDesignType.allCases) { (design) in
					Text(LocalizedStringKey(design.title))
						.tag(design.rawValue)
				}
			}
		}
	}

	private var appTheme: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.appearance, bgColor: .blue)
			Picker("settings.general.colorTheme", selection: $systemTheme) {
				ForEach(SchemeType.allCases) { (theme) in
					Text(LocalizedStringKey(theme.title))
						.tag(theme.rawValue)
				}
			}
		}
	}

	private var onboarding: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.handWave, bgColor: .blue)
			Button {
				isShowingOnboarding.toggle()
			} label: {
				Text("settings.general.onboarding")
			}
		}
	}

	private var badgeSection: some View {
		Section {
			tabBadge
			appBadge
		} header: {
			Label { Text("settings.sections.badge") } icon: { SFSymbols.appBadge }
		} footer: {
			Text("settings.badge.footer")
		}
	}

	private var tabBadge: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.clockBadge, bgColor: .pink)
			Toggle("settings.badge.tab", isOn: $isShowingTabBadge)
				.tint(.accentColor)
		}
	}

	private var appBadge: some View {
		VStack {
			HStack {
				SettingsIcon(icon: SFSymbols.appBadge, bgColor: .teal)
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

	private var miscSection: some View {
		Section {
			tabNames
			confetti
			preview
		} header: {
			Label { Text("settings.sections.misc") } icon: { SFSymbols.bubbleSparkles }
		} footer: {
			Text("settings.misc.footer")
		}
	}

	private var tabNames: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.dock, bgColor: .blue)
			Toggle("settings.misc.tabNames", isOn: $isTabNamesEnabled)
				.tint(.accentColor)
		}
	}

	private var confetti: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.sparkles, bgColor: .pink)
			Toggle("settings.misc.confetti", isOn: $isConfettiEnabled)
				.tint(.accentColor)
		}
	}

	private var preview: some View {
		VStack {
			HStack {
				SettingsIcon(icon: SFSymbols.handTap, bgColor: .indigo)
				Toggle("settings.misc.preview", isOn: $isPreviewEnabled)
					.tint(.accentColor)
			}
			Picker("settings.misc.previewtype.title", selection: $contextPreviewType) {
				ForEach(ContextPreviewType.allCases) { (type) in
					Text(LocalizedStringKey(type.title))
						.tag(type.rawValue)
				}
			}
			.pickerStyle(.segmented)
			.disabled(!isPreviewEnabled)
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
		HStack {
			SettingsIcon(icon: SFSymbols.gearFilled, bgColor: .red)
			Button(role: .destructive) {
				vm.isConfirmingResetSettings.toggle()
			} label: {
				Text("settings.advanced.resetSettings")
			}
		}
	}

	private var resetAppDataButton: some View {
		HStack {
			SettingsIcon(icon: SFSymbols.personFolder, bgColor: .red)
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
