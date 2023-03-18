//
//  DynamicColorLabel.swift
//  TaskGuru
//
//  Created by Joe Pham on 18/3/23.
//  Student ID: 101276573
//

import SwiftUI

/// A view that wraps a `Button` with a closure-style label
/// and adjusts the tint color based on the user's accent color selection.
///
/// `DynamicColorLabel` allows you to create a view with a custom label.
/// The view adjusts its tint color to match the user's accent color selection in settings.
/// Use `DynamicColorLabel` to provide a more dynamic
/// and customizable experience for your users.
///
/// ```
/// var body: some View {
///   DynamicColorLabel {
///     Text("Tap me!")
///       .foregroundColor(.white)
///       .padding()
///   }
/// }
/// ```
struct DynamicColorLabel<Label: View>: View {
	let label: () -> Label
	
	var body: some View {
		Button {} label: { label() }
			.buttonStyle(.borderless)
			.allowsHitTesting(false)
	}
}

struct DynamicColorLabel_Previews: PreviewProvider {
	static var previews: some View {
		DynamicColorLabel(label: { Text("Dynamic Label") })
	}
}
