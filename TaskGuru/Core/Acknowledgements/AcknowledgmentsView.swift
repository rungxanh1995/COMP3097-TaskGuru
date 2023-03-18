//
//	AcknowledgmentsView.swift
//	TaskGuru
//
//	Created by Joe Pham on 2023-02-19.
//	Student ID: 101276573
//

import SwiftUI

struct AcknowledgmentsView: View {
	var body: some View {
		ScrollView {
			VStack(alignment: .center) {
				developmentTeam
				Divider()
				localization
				Divider()
				dependencies
				Divider()
				license
			}
			.multilineTextAlignment(.center)
			.padding()
			.navigationBarTitle("settings.ack.nav.title")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

extension AcknowledgmentsView {
	@ViewBuilder
	private func translationFor(_ language: LocalizedStringKey, translators: String...) -> some View {
		VStack {
			Text(language).font(.headline)
			ForEach(translators, id: \.self) { Text($0) }
			Spacer()
		}
	}

	private var developmentTeam: some View {
		Group {
			Text("settings.ack.devTeam")
				.font(.title3).bold()
			Text("Joe Pham")
			Text("Marco Stevanella")
			Text("Ostap Sulyk")
			Text("Rauf Anata")
		}
	}

	private var localization: some View {
		Group {
			Text("settings.ack.localization")
				.font(.title3).bold()
			Text("settings.ack.localization.subtitle")
				.padding(.bottom)
			
			translationFor("ack.localization.azerbaijani", translators: "Rauf Anata")
			translationFor("ack.localization.italian", translators: "Marco Stevanella")
			translationFor("ack.localization.portugueseBrazil", translators: "Matheus Armando")
			translationFor("ack.localization.ukrainian", translators: "Ostap Sulyk")
			translationFor("ack.localization.vietnamese", translators: "Joe Pham")
		}
	}

	private var dependencies: some View {
		VStack(spacing: 12) {
			Text("settings.ack.dependencies")
				.font(.title3).bold()
			VStack {
				Link(destination: URL(string: "https://github.com/simibac/ConfettiSwiftUI")!) {
					Text("ConfettiSwiftUI")
				}
				Text("Simon Bachmann")
			}
			
			VStack {
				Link(destination: URL(string: "https://github.com/SFSafeSymbols/SFSafeSymbols")!) {
					Text("SFSafeSymbols")
				}
			}
		}
	}

	private var license: some View {
		Group {
			Text("settings.ack.license")
				.font(.title3).bold()
			Text("settings.ack.license.content")
		}
	}
}

struct AcknowledgementsView_Previews: PreviewProvider {
	static var previews: some View {
		AcknowledgmentsView()
	}
}
