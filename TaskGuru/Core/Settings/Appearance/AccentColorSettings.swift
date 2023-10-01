//
//  AccentColorSettings.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-24.
//  Student ID: 101276573
//

import SwiftUI

struct AccentColorSettings: View {
	@Preference(\.accentColor) private var accentColor
	
	var body: some View {
		VStack {
			Form {
				Picker("settings.general.accentColor", selection: $accentColor) {
					ForEach(AccentColorType.allCases) { (accent) in
						Label {
							Text(LocalizedStringKey(accent.title))
						} icon: {
							SFSymbols.circleFilled
								.foregroundStyle(accent.associatedColor)
						}
						.labelStyle(.titleAndIcon)
						.tag(accent.rawValue)
					}
				}
				.labelsHidden()
				.pickerStyle(.inline)
			}
			.navigationTitle("settings.general.accentColor")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct AccentColorSettings_Previews: PreviewProvider {
	static var previews: some View {
		AccentColorSettings()
	}
}
