//
//  Company+ViewModel.swift
//  SpaceX
//
//  Created by David Beleza on 24/10/2021.
//

import Foundation

extension Company {
    public struct ViewModel: Equatable {
        public let text: String

        public init(company: Company.Response) {
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
