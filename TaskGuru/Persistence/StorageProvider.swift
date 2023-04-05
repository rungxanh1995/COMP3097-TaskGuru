//
//  StorageProvider.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-04-05.
//  Student ID: 101276573
//

import CoreData

public protocol StorageProvider {
	var context: NSManagedObjectContext { get }
	func fetch<T>() -> T
	func saveAndHandleError()
}

/// Implementation of a `StorageProvider` for a desired Core Data entity
final public class StorageProviderImpl: StorageProvider {

	/// Singleton instance to use in the app
	static let standard: StorageProviderImpl = .init()

	private let container: NSPersistentContainer
	public let context: NSManagedObjectContext

	private init() {
		container = .init(name: "TaskGuru")
		container.loadPersistentStores { (_, error) in
			if let error = error {
				fatalError("Core Data failed to load: \(error.localizedDescription)")
			}
		}
		context = container.viewContext
	}

	public func fetch<T>() -> T {
		let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
		fetchRequest.sortDescriptors = [
			NSSortDescriptor(key: "cd_dueDate", ascending: true),
			NSSortDescriptor(key: "cd_name", ascending: true)
		]
		// swiftlint:disable force_cast
		return loadTasksAndHandleError(from: fetchRequest) as! T
	}

	private func loadTasksAndHandleError(from request: NSFetchRequest<TaskItem>) -> [TaskItem] {
		do {
			return try context.fetch(request)
		} catch let error {
			print("Error fetching cached tasks. \(error.localizedDescription)")
			return [TaskItem]()
		}
	}

	public func saveAndHandleError() {
		do {
			if context.hasChanges {
				try context.save()
				print("Changes deteched. Data cached successfully!")
			}
		} catch let error {
			print("Error saving data. \(error.localizedDescription)")
		}
	}
}
