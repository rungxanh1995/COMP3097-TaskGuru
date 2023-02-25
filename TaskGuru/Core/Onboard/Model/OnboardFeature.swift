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
			icon: SFSymbols.house,
			title: "onboarding.features.home.title",
			description: "onboarding.features.home.description"),
		OnboardFeature(
			icon: SFSymbols.clockBadge.symbolRenderingMode(.multicolor),
			title: "onboarding.features.pendingTab.title",
			description: "onboarding.features.pendingTab.description"),
		OnboardFeature(
			icon: SFSymbols.appBadge.symbolRenderingMode(.multicolor),
			title: "onboarding.features.appBadge.title",
			description: "Track all or time-based pending tasks at a glance. Find this in \(SFSymbols.gear) Settings"),
		OnboardFeature(
			icon: SFSymbols.menu,
			title: "onboarding.features.quickActions.title",
			description: "onboarding.features.quickActions.description")
	]
}
