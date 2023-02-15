//
//  UIApplication.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-14.
//

import UIKit

extension UIApplication {
	/// Can be used to help with determining portrait lock
	///
	///	Check out the discussions to use here
	/// https://stackoverflow.com/questions/73124396/is-force-view-controller-orientation-working-in-ios-16-beta/73735976
	///
	/// https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0
	class func navigationTopViewController() -> UIViewController? {
		let keyWindow = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
		guard let nav = keyWindow?.rootViewController as? UINavigationController else { return nil }
		return nav.topViewController
	}
}
