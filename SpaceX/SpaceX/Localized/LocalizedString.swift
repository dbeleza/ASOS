//
//  LocalizedString.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

enum LocalizedString: String {
    case company
    case companyName
    case companyDescription
    case mission
    case dateTime
    case rocket
    case daysFrom
    case daysSince
    case launches
    case at
    case sort
    case noInternet
    case errorTitle
    case error
    case ok
    case retry
    case article
    case wikipedia
    case youtube
    case articleDetailDescription
    case notDefined
    case filterState
    case filterDescription
    case filterNote
    case ascendent
    case descendent
    case save
    case close
    case noResults

    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "Missing String")
    }
}
