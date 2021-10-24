//
//  Filter+State.swift
//  SpaceX
//
//  Created by David Beleza on 24/10/2021.
//

import Foundation

extension Filter {
    
    public struct State: Equatable {
        public var isSuccess: Bool
        public var selectedYear: String
        public var isAscending: Bool
    }
}
