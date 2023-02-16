//
//  HapticManager.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-15.
//

import UIKit

private final class HapticManager {
	static let shared: HapticManager = .init()
	private let feedback: UINotificationFeedbackGenerator = .init()
	
	private init() { }
	
	func trigger(_ notifType: UINotificationFeedbackGenerator.FeedbackType) {
		feedback.notificationOccurred(notifType)
	}
}

func haptic(_ notifType: UINotificationFeedbackGenerator.FeedbackType) {
	if !UserDefaults.standard.bool(forKey: UserDefaultsKey.hapticsReduced) {
		HapticManager.shared.trigger(notifType)
	}
}
