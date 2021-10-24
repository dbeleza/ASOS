//
//  Launch.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public struct Launch {

    public struct ListResponse: Codable, Equatable {

        let list: [Response]
        let totalResults: Int

        public enum CodingKeys: String, CodingKey {
            case list = "docs"
            case totalResults = "totalDocs"
        }

        public init(list: [Response], totalResults: Int) {
            self.list = list
            self.totalResults = totalResults
        }
    }
}
