//
//  SettingsIcon.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-24.
//  Student ID: 101276573
//

import SwiftUI

struct SettingsIcon: View {
	let icon: Image
	let bgColor: Color
	
	var body: some View {
		VStack {
			icon
				.resizable()
				.scaledToFit()
				.frame(width: 20, height: 20)
		}
		.background(in: RoundedRectangle(cornerRadius: 3).inset(by: -4))
		.backgroundStyle(bgColor)
		.foregroundStyle(.white)
		.padding(4)
	}
}

struct SettingsIcon_Previews: PreviewProvider {
	static var previews: some View {
		SettingsIcon(icon: SFSymbols.paintbrush, bgColor: .pink)
			.previewLayout(.sizeThatFits)
	}
}
