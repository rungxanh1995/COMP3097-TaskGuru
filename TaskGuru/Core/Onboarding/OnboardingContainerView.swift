//
//  OnboardingContainerView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-14.
//

import SwiftUI

struct OnboardingContainerView: View {
	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool?
	
	var body: some View {
		VStack {
			TabView {
				ForEach(OnboardFeature.features) { feature in
					OnboardingView(
						icon: feature.icon,
						title: feature.title,
						description: feature.description)
				}
			}
			.tabViewStyle(.page(indexDisplayMode: .always))
			.indexViewStyle(.page(backgroundDisplayMode: .always))
			.padding(.bottom)
			
			if isOnboarding == nil {
				Button("Get Started") {
					withAnimation {	isOnboarding = false }
				}
				.bold()
				.buttonStyle(.bordered)
				.tint(.accentColor)
			}
		}
	}
}

struct OnboardingContainerView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingContainerView()
	}
}
