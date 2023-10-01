//
//  AppearanceScreen.swift
//  TaskGuru
//
//  Created by Joe Pham on 17/3/23.
//  Student ID: 101276573
//

import SwiftUI

struct AppearanceScreen: View {
	@Preference(\.activeAppIcon) private var activeAppIcon
	@Preference(\.accentColor) private var accentColor
	@Preference(\.systemTheme) private var systemTheme
	@Preference(\.fontDesign) private var fontDesign
	@Preference(\.fontWidth) private var fontWidth
	@Preference(\.isBoldFont) private var boldFont
	@Preference(\.isTodayDuesHighlighted) private var duesHighlighted
	@Preference(\.isShowingTaskNotesInLists) private var isShowingTaskNotesInLists
	
	@Preference(\.isTabNamesEnabled) private var isTabNamesEnabled
	@Preference(\.isConfettiEnabled) private var isConfettiEnabled
	@Preference(\.isPreviewEnabled) private var isPreviewEnabled
	@Preference(\.contextPreviewType) private var contextPreviewType
	
	var body: some View {
		Form {
			Section {
				appIcon
				appAccentColor
				colorTheme
			}
			
			Section {
				fontDesignStyle
				fontWidthStyle
					.disabled(FontDesignType(rawValue: fontDesign) != .system)
			} footer: {
				Text("settings.appearance.footer")
			}
			
			Section { boldText }
			
			Section {
				highlightDues
				showTaskNotes
			}

			
			miscSection
		}
		.navigationTitle("settings.general.appearance")
		.navigationBarTitleDisplayMode(.inline)
	}
}

extension AppearanceScreen {
	private var appIcon: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.app, accent: .appGreen)
		} content: {
			NavigationLink {
				AppIconSettings()
			} label: {
				HStack {
					Text("settings.general.appIcon")
					Spacer()
					if let icon = AppIconType(rawValue: activeAppIcon)?.iconImage {
						icon.asSettingsIcon()
					} else {
						Image("app-logo").asSettingsIcon()
					}
				}
			}
		}
	}
	
	@ViewBuilder private var appAccentColor: some View {
		let currentAccentColor = AccentColorType(rawValue: accentColor)
		settingsRow {
			SettingsIcon(icon: SFSymbols.paintbrush, accent: .defaultAccentColor)
		} content: {
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
	
	private var colorTheme: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.appearance, accent: .appBlue)
		} content: {
			Picker("settings.general.colorTheme", selection: $systemTheme) {
				ForEach(SchemeType.allCases) { (theme) in
					Text(LocalizedStringKey(theme.title))
						.tag(theme.rawValue)
				}
			}
		}
	}
	
	private var fontDesignStyle: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.textFormat, accent: .appOrange)
		} content: {
			Picker("settings.general.fontStyle", selection: $fontDesign) {
				ForEach(FontDesignType.allCases) { (design) in
					Text(LocalizedStringKey(design.title))
						.tag(design.rawValue)
				}
			}
		}
	}
	
	private var fontWidthStyle: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.arrowLeftRight, accent: .appYellow)
		} content: {
			Picker("settings.general.fontWidth", selection: $fontWidth) {
				ForEach(FontWidthType.allCases) { (width) in
					Text(LocalizedStringKey(width.title))
						.tag(width.rawValue)
				}
			}
		}
	}
	
	private var boldText: some View {
		Toggle("settings.general.boldText", isOn: $boldFont)
	}
	
	private var highlightDues: some View {
		Toggle("settings.general.highlight", isOn: $duesHighlighted)
	}

	private var showTaskNotes: some View {
		Toggle(
			"settings.general.showTaskNotesInLists",
			isOn: $isShowingTaskNotesInLists
		)
	}
	
	private var miscSection: some View {
		Section {
			tabNames
			confetti
			preview
		} header: {
			Label {
				Text("settings.sections.misc")
			} icon: { SFSymbols.bubbleSparkles }
		} footer: {
			Text("settings.misc.footer")
		}
	}
	
	private var tabNames: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.dock, accent: .appBlue)
		} content: {
			Toggle("settings.misc.tabNames", isOn: $isTabNamesEnabled)
				.tint(.accentColor)
		}
	}
	
	private var confetti: some View {
		settingsRow {
			SettingsIcon(icon: SFSymbols.sparkles, accent: .appPink)
		} content: {
			Toggle("settings.misc.confetti", isOn: $isConfettiEnabled)
				.tint(.accentColor)
		}
	}
	
	private var preview: some View {
		VStack {
			settingsRow {
				SettingsIcon(icon: SFSymbols.handTap, accent: .appIndigo)
			} content: {
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
}

struct AppearanceSettingsView_Previews: PreviewProvider {
	static var previews: some View {
		AppearanceScreen()
	}
}
