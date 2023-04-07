//
//  HapticManager.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-16.
//	Student ID: 101276573
//

import CoreHaptics
import UIKit

public final class HapticManager {
	static let shared: HapticManager = .init()

	public enum HapticType {
		case buttonPress
		case notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
		case tabSelection
	}

	private let selectionGenerator: UISelectionFeedbackGenerator = .init()
	private let impactGenerator: UIImpactFeedbackGenerator = .init(style: .rigid)
	private let feedbackGenerator: UINotificationFeedbackGenerator = .init()

	private var supportsHaptics: Bool {
		CHHapticEngine.capabilitiesForHardware().supportsHaptics
	}

	private init() {
		selectionGenerator.prepare()
		impactGenerator.prepare()
		feedbackGenerator.prepare()
	}

	func trigger(_ type: HapticType) {
		guard supportsHaptics else { return }
		
		switch type {
		case .buttonPress:
			impactGenerator.impactOccurred()
		case let .notification(type):
			feedbackGenerator.notificationOccurred(type)
		case .tabSelection:
			selectionGenerator.selectionChanged()
		}
	}
}

public func haptic(_ type: HapticManager.HapticType) {
	if UserDefaults.standard.bool(forKey: UserDefaultsKey.hapticsReduced) == false {
		HapticManager.shared.trigger(type)
	}
}
