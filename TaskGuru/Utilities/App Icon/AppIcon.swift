//
//  AppIcon.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-22.
//	Student ID: 101276573
//

import SwiftUI

enum AppIconType: Int, Identifiable, CaseIterable {
	var id: Self { self }
	case dew, spring, summer, fall, winter, sky, midnight, iris, berry
}

extension AppIconType {
	/// Used as reference to localizable string key
	var title: String {
		switch self {
		case .dew: return "appIcon.dew"
		case .spring: return "appIcon.spring"
		case .summer: return "appIcon.summer"
		case .fall: return "appIcon.fall"
		case .winter: return "appIcon.winter"
		case .sky: return "appIcon.sky"
		case .midnight: return "appIcon.midnight"
		case .iris: return "appIcon.iris"
		case .berry: return "appIcon.berry"
		}
	}

	/// Used as direct reference to icon image name in Assets catalog
	var assetName: String {
		switch self {
		case .dew: return "AppIconDew"
		case .spring: return "AppIconSpring"
		case .summer: return "AppIconSummer"
		case .fall: return "AppIconFall"
		case .winter: return "AppIconWinter"
		case .sky: return "AppIconSky"
		case .midnight: return "AppIconMidnight"
		case .iris: return "AppIconIris"
		case .berry: return "AppIconBerry"
		}
	}

	/// Used to display as accompanying icon image
	var iconImage: Image {
		switch self {
		case .dew:
			return Image(uiImage: .init(named: AppIconType.dew.assetName)!)
		case .spring:
			return Image(uiImage: .init(named: AppIconType.spring.assetName)!)
		case .summer:
			return Image(uiImage: .init(named: AppIconType.summer.assetName)!)
		case .fall:
			return Image(uiImage: .init(named: AppIconType.fall.assetName)!)
		case .winter:
			return Image(uiImage: .init(named: AppIconType.winter.assetName)!)
		case .sky:
			return Image(uiImage: .init(named: AppIconType.sky.assetName)!)
		case .midnight:
			return Image(uiImage: .init(named: AppIconType.midnight.assetName)!)
		case .iris:
			return Image(uiImage: .init(named: AppIconType.iris.assetName)!)
		case .berry:
			return Image(uiImage: .init(named: AppIconType.berry.assetName)!)
		}
	}
}
