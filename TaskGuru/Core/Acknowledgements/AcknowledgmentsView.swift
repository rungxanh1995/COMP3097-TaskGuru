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
				dependencies
				Divider()
				license
			}
			.multilineTextAlignment(.center)
			.padding()
			.navigationBarTitle("Acknowledgments")
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

extension AcknowledgmentsView {
	private var developmentTeam: some View {
		Group {
			Text("Development Team")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Text("Joe Pham")
			Text("Marco Stevanella")
			Text("Ostap Sulyk")
			Text("Rauf Anata")
		}
	}
	
	private var dependencies: some View {
		Group {
			Text("Third Party Dependencies")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Link(destination: URL(string: "https://github.com/simibac/ConfettiSwiftUI")!) {
				Text("ConfettiSwiftUI")
			}
			Text("Simon Bachmann")
		}
	}
	
	private var license: some View {
		Group {
			Text("License")
				.font(.title3).bold()
				.foregroundColor(.defaultAccentColor)
			Text("settings.acknowledgements.license.content")
		}
	}
}

struct AcknowledgementsView_Previews: PreviewProvider {
	static var previews: some View {
		AcknowledgmentsView()
	}
}
