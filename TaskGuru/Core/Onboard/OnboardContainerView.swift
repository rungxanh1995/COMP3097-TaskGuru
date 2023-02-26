//
//  OnboardContainerView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-16.
//	Student ID: 101276573
//

import SwiftUI

struct OnboardContainerView: View {
	@AppStorage(UserDefaultsKey.isOnboarding)
	private var isOnboarding: Bool?
	
	@Environment(\.dismiss) private var dismissThisView
	
	var body: some View {
		VStack {
			TabView {
				ForEach(OnboardFeature.features) { feature in
					OnboardView(
						icon: feature.icon,
						title: feature.title,
						description: feature.description)
				}
			}
			.tabViewStyle(.page(indexDisplayMode: .always))
			.indexViewStyle(.page(backgroundDisplayMode: .always))
			
			switch isOnboarding {
			case .none: allSet
			case .some: EmptyView()
			}
		}
		.padding(.bottom)
	}
}

extension OnboardContainerView {
	/// Button to display when user is new to the app
	private var allSet: some View {
		Button("onboarding.buttons.onboarding.dismiss") {
			withAnimation {	isOnboarding = false }
			haptic(.success)
		}
		.bold()
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
		.tint(.defaultAccentColor)
	}
}

struct OnboardContainerView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardContainerView()
	}
}
