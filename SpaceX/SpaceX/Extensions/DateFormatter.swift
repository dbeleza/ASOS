//
//  DateFormatter.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

extension DateFormatter {
    static let shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()

    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()

    // MARK: Year Formatter
    // Because DateFormatter instantiation is heavy, I've decided to create a private static var
    private static var yearDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    static func getYearFromDate(_ date: Date) -> String {
        return Self.yearDateFormatter.string(from: date)
    }
}
