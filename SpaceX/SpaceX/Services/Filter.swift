//
//  Filter.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public struct Filter {

    public struct ViewModel {
        public let years: [String]
        public let isAscending: Bool
        public let isSuccess: Bool
        public let preselectYearIndex: Int
    }

    public struct State: Equatable {
        public var isSuccess: Bool
        public var selectedYear: String
        public var isAscending: Bool
    }
}
