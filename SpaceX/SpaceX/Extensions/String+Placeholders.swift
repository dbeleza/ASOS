//
//  String+Placeholders.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

extension String {
    enum Placeholder: String {
        case companyName
        case companyFounderName = "founderName"
        case companyFoundedYear = "year"
        case companyTotalEmployees = "employees"
        case companyLaunchSites = "launch_sites"
        case companyValuation = "valuation"
    }

    mutating func replacePlaceholder(_ placeholder: Placeholder,
                            withValue value: String,
                            delimiterStart: String = "{",
                            delimiterEnd: String = "}") {
        self = self.replacingOccurrences(of: "\(delimiterStart)\(placeholder.rawValue)\(delimiterEnd)", with: value)
    }
}
