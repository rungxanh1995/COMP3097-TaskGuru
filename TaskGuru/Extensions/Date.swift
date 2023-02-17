//
//  Date.swift
//  TaskGuru
//
//  Created by Joe Pham on 2023-01-31.
//	Student ID: 101276573
//	Credit: https://github.com/SwifterSwift/SwifterSwift/blob/master/Sources/SwifterSwift/Foundation/DateExtensions.swift

import Foundation

extension Date {
	
	/// User’s current calendar.
	private var calendar: Calendar { Calendar.current }
	
	/// Check if date is within today
	var isWithinToday: Bool { calendar.isDateInToday(self) }
	
	/// Check if date is already in the past
	///
	/// 	Date(timeInterval: -100, since: Date()).isInPast -> true
	///
	var isInThePast: Bool { self < Date() }
	
	/// Check if date is within yesterday
	var isInYesterday: Bool { calendar.isDateInYesterday(self) }
	
	/// Check if date is already past today, aka overdue (regarding a task)
	var isPastToday: Bool { !isWithinToday && !isInTheFuture }
	
	/// Check if date is in the future.
	///
	/// 	Date(timeInterval: 100, since: Date()).isInFuture -> true
	///
	var isInTheFuture: Bool { self > Date() }
}
