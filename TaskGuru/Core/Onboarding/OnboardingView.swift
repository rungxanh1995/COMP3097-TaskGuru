//
//  OnboardingView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-14.
//

import SwiftUI

struct OnboardingView: View {
	let icon: Image
	let title: LocalizedStringKey
	let description: LocalizedStringKey
	
	var body: some View {
		VStack(alignment: .center, spacing: 12) {
			icon
				.resizable()
				.scaledToFit()
				.frame(width: 100, height: 100)
				.foregroundColor(.accentColor)
			
			Text(title)
				.font(.title)
				.bold()
			
			Text(description)
				.multilineTextAlignment(.center)
				.foregroundColor(.secondary)
		}
		.padding(.horizontal, 20)
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView(
			icon: OnboardFeature.features[1].icon,
			title: OnboardFeature.features[1].title,
			description: OnboardFeature.features[1].description)
	}
}
