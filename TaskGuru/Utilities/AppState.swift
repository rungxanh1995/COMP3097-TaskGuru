//
//  AppState.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-13.
//	Student ID: 101276573
//

import SwiftUI

final class AppState: ObservableObject {
	@Published var navPath: NavigationPath = .init()
	
	/// Clears the navigation path, so the current view pops to its root view.
	func popToRoot() {
		navPath.removeLast(navPath.count)
	}
}
