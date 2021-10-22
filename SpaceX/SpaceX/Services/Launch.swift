//
//  Launch.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public struct Launch {
    public struct ListResponse: Codable, Equatable {
        public struct Response: Codable, Equatable {
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

                public init(images: Images?, articleLink: String?, wikipediaLink: String?, youtubeLink: String?) {
                    self.images = images
                    self.articleLink = articleLink
                    self.wikipediaLink = wikipediaLink
                    self.youtubeLink = youtubeLink
                }

                public enum CodingKeys: String, CodingKey {
                    case images = "patch"
                    case articleLink = "article"
                    case wikipediaLink = "wikipedia"
                    case youtubeLink = "webcast"
                }
            }
            public struct Rocket: Codable, Equatable {
                public let name: String
                public let type: String

                public init(name: String, type: String) {
                    self.name = name
                    self.type = type
                }
            }
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

            public init(id: String, missionName: String, launchDateUnix: Int, launchSuccess: Bool?, metadata: Metadata, rocket: Rocket) {
                self.id = id
                self.missionName = missionName
                self.launchDateUnix = launchDateUnix
                self.launchSuccess = launchSuccess
                self.metadata = metadata
                self.rocket = rocket
            }
        }

        public enum CodingKeys: String, CodingKey {
            case list = "docs"
            case totalResults = "totalDocs"
        }

        let list: [Response]
        let totalResults: Int

        public init(list: [Response], totalResults: Int) {
            self.list = list
            self.totalResults = totalResults
        }
    }
}

// MARK: - Request
extension Launch {
    public struct Request: Encodable {
        public struct Query: Encodable {
            public struct DateRange: Encodable {
                public enum CodingKeys: String, CodingKey {
                    case start = "$gte"
                    case end = "$lte"
                }
                let start: String
                let end: String
                init(year: String) {
                    self.start = "\(year)-01-01T00:00:00.000Z"
                    self.end = "\(year)-12-31T23:59:59.000Z"
                }
            }
            let date_utc: DateRange?
            let success: Bool?
        }

        public struct Options: Encodable {
            struct Populate: Encodable {
                var path = "rocket"
                var select = ["name", "type"]
            }
            struct Sort: Encodable {
                let date_utc: String
            }
            let limit: Int
            let offset: Int
            var select = ["name", "date_unix", "links", "success"]
            var populate = Populate()
            let sort: Sort?
        }

        let query: Query?
        let options: Options?
    }
}

// MARK: - ViewModel
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
        public let launchSuccess: Bool
        public let launchDaysTitle: String?
        public let launchDays: Int?
        public let metadata: Metadata
        public let rocket: Rocket

        public init(id: String, missionName: String, launchDate: String, launchTime: String, launchSuccess: Bool, launchDays: Int?, launchDaysTitle: String?, metadata: Metadata, rocket: Rocket) {
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
