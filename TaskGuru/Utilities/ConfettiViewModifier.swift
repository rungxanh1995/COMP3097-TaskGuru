//
//  ConfettiViewModifier.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-22.
//	Student ID: 101276573
//

import SwiftUI
import ConfettiSwiftUI

struct ConfettiViewModifier: ViewModifier {
	@Binding var counter: Int
	
	func body(content: Content) -> some View {
		content
			.confettiCannon(
				counter: $counter, num: 75, openingAngle: Angle(degrees: 0),
				closingAngle: Angle(degrees: 360), radius: 300)
	}
}
