//
//  Company.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public struct Company {
    public struct Response: Codable, Equatable {
        public let name: String
        public let founder: String
        public let founded: Int
        public let employees: Int
        public let launchSites: Int
        public let valuation: Int

        public enum CodingKeys: String, CodingKey {
            case name
            case founder
            case founded
            case employees
            case launchSites = "launch_sites"
            case valuation
        }

        public init(name: String, founder: String, founded: Int, employees: Int, launchSites: Int, valuation: Int) {
            self.name = name
            self.founder = founder
            self.founded = founded
            self.employees = employees
            self.launchSites = launchSites
            self.valuation = valuation
        }
    }

    public struct ViewModel: Equatable {
        public let text: String

        public init(company: Response) {
            var text = LocalizedString.companyDescription.localized
            text.replacePlaceholder(.companyName, withValue: company.name)
            text.replacePlaceholder(.companyFoundedYear, withValue: String(company.founded))
            text.replacePlaceholder(.companyFounderName, withValue: company.founder)
            text.replacePlaceholder(.companyLaunchSites, withValue: String(company.launchSites))
            text.replacePlaceholder(.companyTotalEmployees, withValue: String(company.employees))
            text.replacePlaceholder(.companyValuation, withValue: String(company.valuation))
            self.text = text
        }
    }
}
