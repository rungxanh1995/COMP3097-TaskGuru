//
//  OnboardView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-16.
//	Student ID: 101276573
//

import SwiftUI

struct OnboardView: View {
	let icon: Image
	let title: LocalizedStringKey
	let description: LocalizedStringKey
	
	var body: some View {
		HStack(spacing: 16) {
			DynamicColorLabel {
				icon.asIconSize()
			}

			VStack(alignment: .leading) {
				Text(title)
					.font(.headline)
					.bold()
					.multilineTextAlignment(.leading)

				Text(description)
					.multilineTextAlignment(.leading)
					.foregroundColor(.secondary)
			}
		}
		.padding(.horizontal, 12)
	}
}

struct OnboardView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardView(
			icon: OnboardFeature.features[1].icon,
			title: OnboardFeature.features[1].title,
			description: OnboardFeature.features[1].description)
	}
}

