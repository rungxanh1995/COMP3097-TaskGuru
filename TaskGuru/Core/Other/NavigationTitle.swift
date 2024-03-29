//
//  NavigationTitle.swift
//  TaskGuru
//
//  Created by Marco Stevanella on 2023-02-17.
//  Student ID: 101307949
//

import SwiftUI

/// Intended as a replacement of a `NavigationStack` or `NavigationView` title.
///
/// Sample usage:
/// ```
/// NavigationView {
///	  List {
///      // Your view here
///   }
///   .toolbar {
///	    ToolbarItem(placement: .principal) {
///	      NavigationTitle(text: "Custom Navigation Title")
///	    }
///	  }
/// }
/// ```
struct NavigationTitle: View {
	let text: LocalizedStringKey

	var body: some View {
		DynamicColorLabel { Text(text) }
			.font(.headline)
			.bold()
	}
}

struct GradientNavigationTitle_Previews: PreviewProvider {
	static var previews: some View {
		NavigationTitle(text: "All Tasks")
	}
}
