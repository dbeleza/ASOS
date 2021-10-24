//
//  Launch+Response.swift
//  SpaceX
//
//  Created by David Beleza on 24/10/2021.
//

import Foundation

extension Launch.ListResponse {
// MARK: - 📜 Response
    public struct Response: Codable, Equatable {
        public let id: String
        public let missionName: String
        public let launchDateUnix: Int
        public let launchSuccess: Bool?
        public let metadata: Metadata
        public let rocket: Rocket

        public enum CodingKeys: String, CodingKey {
            case id = "id"
            case missionName = "name"
            case launchDateUnix = "date_unix"
            case launchSuccess = "success"
            case metadata = "links"
            case rocket = "rocket"
        }

        public init(id: String,
                    missionName: String,
                    launchDateUnix: Int,
                    launchSuccess: Bool?,
                    metadata: Metadata,
                    rocket: Rocket) {
            self.id = id
            self.missionName = missionName
            self.launchDateUnix = launchDateUnix
            self.launchSuccess = launchSuccess
            self.metadata = metadata
            self.rocket = rocket
        }
    }
}

// MARK: - 🏞 Response Metadata
extension Launch.ListResponse.Response {

    public struct Metadata: Codable, Equatable {

        public struct Images: Codable, Equatable {
            public let small: String?
            public let large: String?
            public init(small: String?, large: String?) {
                self.small = small
                self.large = large
            }
        }

        public let images: Images?
        public let articleLink: String?
        public let wikipediaLink: String?
        public let youtubeLink: String?

        public enum CodingKeys: String, CodingKey {
            case images = "patch"
            case articleLink = "article"
            case wikipediaLink = "wikipedia"
            case youtubeLink = "webcast"
        }

        public init(images: Images?, articleLink: String?, wikipediaLink: String?, youtubeLink: String?) {
            self.images = images
            self.articleLink = articleLink
            self.wikipediaLink = wikipediaLink
            self.youtubeLink = youtubeLink
        }
    }
}

// MARK: - 🚀 Response Rocket
extension Launch.ListResponse.Response {

    public struct Rocket: Codable, Equatable {
        public let name: String
        public let type: String

        public init(name: String, type: String) {
            self.name = name
            self.type = type
        }
    }
}
