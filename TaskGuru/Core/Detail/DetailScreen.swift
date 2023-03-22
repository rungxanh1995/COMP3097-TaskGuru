//
//  DetailScreen.swift
//  TaskGuru
//
//  Created by Ostap Sulyk on 2023-02-06.
//	Student ID: 101186901
//


import SwiftUI

struct DetailScreen: View {
	@ObservedObject var vm: DetailScreen.ViewModel
	
	var body: some View {
		DetailScreen.ViewMode(vm: vm)
	}
}

struct DetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			DetailScreen(vm: .init(for: dev.task, parentVM: dev.homeVM))
		}
	}
}

