//
//  PreferenceWrapper.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-02-15.
//	Link: https://www.avanderlee.com/swift/appstorage-explained/
//

import SwiftUI

@propertyWrapper
struct Preference<Value>: DynamicProperty {
	
	@ObservedObject
	private var preferencesObserver: PublisherObservableObject
	private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
	private let preferences: Preferences
	
	init(_ keyPath: ReferenceWritableKeyPath<Preferences, Value>, preferences: Preferences = .standard) {
		self.keyPath = keyPath
		self.preferences = preferences
		let publisher = preferences
			.preferencesChangedSubject
			.filter { changedKeyPath in
				changedKeyPath == keyPath
			}.map { _ in () }
			.eraseToAnyPublisher()
		self.preferencesObserver = .init(publisher: publisher)
	}
	
	var wrappedValue: Value {
		get { preferences[keyPath: keyPath] }
		nonmutating set { preferences[keyPath: keyPath] = newValue }
	}
	
	var projectedValue: Binding<Value> {
		Binding(
			get: { wrappedValue },
			set: { wrappedValue = $0 }
		)
	}
}
