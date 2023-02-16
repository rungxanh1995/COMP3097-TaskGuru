//
//  OnboardingContainerView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-14.
//	Student ID: 101276573
//

import SwiftUI

struct OnboardingContainerView: View {
	@AppStorage(UserDefaultsKey.isOnboarding)
	private var isOnboarding: Bool?
	
	@Environment(\.dismiss) private var dismissThisView
	
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
			
			switch isOnboarding {
			case .none: allSet
			case .some: dismiss
			}
		}
	}
}

extension OnboardingContainerView {
	/// Button to display when user is new to the app
	private var allSet: some View {
		Button("I'm All Set!") {
			withAnimation {	isOnboarding = false }
			haptic(.success)
		}
		.bold()
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
		.tint(.accentColor)
	}
	
	/// Button to display when user might be seeing this view in Settings
	private var dismiss: some View {
		Button {
			dismissThisView()
			haptic(.success)
		} label: {
			Label {
				Text("Dismiss")
			} icon: {
				SFSymbols.xmark
			}
			.labelStyle(.titleOnly)
		}
		.bold()
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
		.tint(.gray)
	}
}

struct OnboardingContainerView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingContainerView()
	}
}
