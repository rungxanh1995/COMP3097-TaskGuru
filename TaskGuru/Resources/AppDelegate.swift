//
//  AppDelegate.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-14.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
	
	static var orientationLock = UIInterfaceOrientationMask.all
	
	func application(
		_ application: UIApplication,
		supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
			return AppDelegate.orientationLock
		}
	
	func lockInPortraitMode() {
		if #available(iOS 16.0, *) {
			let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
			windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
			
			UIApplication.navigationTopViewController()?.setNeedsUpdateOfSupportedInterfaceOrientations()
		} else {
			UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
		}
		
		AppDelegate.orientationLock = .portrait
	}
	
	func unlockPortraitMode() {
		AppDelegate.orientationLock = .all
	}
}
