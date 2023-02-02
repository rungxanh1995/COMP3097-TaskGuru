//
//  SettingsView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//

import SwiftUI

struct SettingsView: View {
	@State private var isHapticEnabled = true
	
	private let colorThemes = ["System", "Light", "Dark"]
	@State private var selectedColorTheme = "System"
	
	@State private var isConfirmingResetData = false
	
	var body: some View {
		NavigationView {
			Form {
				generalSection
				advancedSection
				devTeamSection
			}
			.navigationTitle("Settings")
			.confirmationDialog(
				"You're about to reset all data.\nThis action cannot be undone",
				isPresented: $isConfirmingResetData,
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
			haptics
			appTheme
		} header: {
			HStack {
				SFSymbols.gearFilled
				Text("General")
			}
		}
	}
	
	
	private var haptics: some View {
		Toggle("Enable Haptics", isOn: $isHapticEnabled)
			.tint(Color.accentColor)
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
			resetAppButton
		} header: {
			HStack {
				SFSymbols.magicWand
				Text("Advanced")
			}
		} footer: {
			Text("Be careful, this removes all your data! Restart the app to see all changes")
		}
	}
	
	private var resetAppButton: some View {
		Button("Reset to Original", role: .destructive) {
			isConfirmingResetData.toggle()
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
