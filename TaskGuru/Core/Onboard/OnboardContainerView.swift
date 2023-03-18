//
//  OnboardContainerView.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-16.
//	Student ID: 101276573
//

import SwiftUI

struct OnboardContainerView: View {
	@AppStorage(UserDefaultsKey.isOnboarding) private var isOnboarding: Bool?
	@Preference(\.activeAppIcon) private var activeAppIcon

	@Environment(\.dismiss) private var dismissThisView

	var body: some View {
		VStack {
			ScrollView(showsIndicators: false) {
				VStack(alignment: .center) {
					// welcome to
					Text("onboarding.title")
						.font(.largeTitle)
						.fontWeight(.bold)
						.multilineTextAlignment(.center)
				}
				.padding(.horizontal, 40)
				.padding(.vertical, 32)

				VStack(alignment: .leading, spacing: 24) {
					ForEach(OnboardFeature.features) { feature in
						OnboardView(
							icon: feature.icon,
							title: feature.title,
							description: feature.description)
					}
				}
				.padding(.bottom)
			}
			
			dataPrivacy

			switch isOnboarding {
			case .none: allSet
			case .some: EmptyView()
			}
		}
		.padding(.horizontal, 20)
	}
}

extension OnboardContainerView {
	/// Button to display when user is new to the app
	private var allSet: some View {
		Button {
			withAnimation {	isOnboarding = false }
		} label: {
			Text("onboarding.buttons.onboarding.dismiss")
				.padding(.vertical, 8)
				.frame(maxWidth: .infinity)
		}
		.bold()
		.buttonStyle(.borderedProminent)
		.buttonBorderShape(.roundedRectangle(radius: 16))
		.padding(.bottom)
	}

	private var dataPrivacy: some View {
		VStack {
			DynamicColorLabel {
				Image(systemSymbol: .personBadgeShieldCheckmarkFill)
					.symbolRenderingMode(.hierarchical)
					.asSettingsIcon()
			}
			Text("onboarding.privacy")
				.font(.caption2)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
		}
	}
}

struct OnboardContainerView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardContainerView()
	}
}
