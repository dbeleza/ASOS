//
//  Filter.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public struct Filter {
    public enum SortOptions: Int {
        case asc
        case desc

        var string: String {
            switch self {
            case .asc:
                return LocalizedString.ascendent.localized
            case .desc:
                return LocalizedString.descendent.localized
            }
        }
    }

    public struct ViewModel {
        public let years: [String]
        public let sortOptions: [SortOptions]
        public let isFilterOn: Bool
        public let preselectYearIndex: Int
        public let preselectSortIndex: Int
    }

    public struct State: Equatable {
        public var isFilterOn: Bool?
        public var selectedYear: String?
        public var selectedSortOrderIndex: Int?
    }
}
