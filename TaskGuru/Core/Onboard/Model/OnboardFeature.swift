//
//  OnboardFeature.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-16.
//	Student ID: 101276573
//

import SwiftUI

struct OnboardFeature: Identifiable {
	var id: UUID = .init()
	let icon: Image
	let title: LocalizedStringKey
	let description: LocalizedStringKey
}

extension OnboardFeature {
	static let features: [OnboardFeature] = [
		OnboardFeature(
			icon: SFSymbols.bulletList,
			title: "onboarding.features.home.title",
			description: "onboarding.features.home.description"),
		OnboardFeature(
			icon: SFSymbols.clockBadge.symbolRenderingMode(.multicolor),
			title: "onboarding.features.pendingTab.title",
			description: "onboarding.features.pendingTab.description"),
		OnboardFeature(
			icon: SFSymbols.menu,
			title: "onboarding.features.quickActions.title",
			description: "onboarding.features.quickActions.description"),
		OnboardFeature(
			icon: SFSymbols.paintbrush,
			title: "onboarding.features.customization.title",
			description: "onboarding.features.customization.description")
	]
}
