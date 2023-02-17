//
//  OnboardFeature.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-14.
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
			title: "Home tab",
			description: "Tasks categorized by section to easily track overdue, due today, and upcoming ones"),
		OnboardFeature(
			icon: SFSymbols.clockBadge,
			title: "Pending Tasks tab",
			description: "Find your undone tasks here"),
		OnboardFeature(
			icon: SFSymbols.menu,
			title: "Quick Actions",
			description: "Tap and hold each task from the list to use quick actions")
	]
}
