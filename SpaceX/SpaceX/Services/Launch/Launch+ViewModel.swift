//
//  Launch+ViewModel.swift
//  SpaceX
//
//  Created by David Beleza on 24/10/2021.
//

import Foundation

extension Launch {

    public struct ViewModel: Equatable {

        public struct Metadata: Equatable {
            public let smallThumbnail: String?
            public let bigThumbnail: String?
            public let articleLink: String?
            public let wikipediaLink: String?
            public let youtubeLink: String?
        }

        public struct Rocket: Equatable {
            public let name: String
            public let type: String
        }

        public let id: String
        public let missionName: String
        public let launchDate: String
        public let launchTime: String
        public let launchSuccess: Bool?
        public let launchDaysTitle: String?
        public let launchDays: Int?
        public let metadata: Metadata
        public let rocket: Rocket

        public init(id: String,
                    missionName: String,
                    launchDate: String,
                    launchTime: String,
                    launchSuccess: Bool?,
                    launchDays: Int?,
                    launchDaysTitle: String?,
                    metadata: Metadata,
                    rocket: Rocket) {
            self.id = id
            self.missionName = missionName
            self.launchDate = launchDate
            self.launchTime = launchTime
            self.launchSuccess = launchSuccess
            self.launchDays = launchDays
            self.launchDaysTitle = launchDaysTitle
            self.metadata = metadata
            self.rocket = rocket
        }
    }
}
