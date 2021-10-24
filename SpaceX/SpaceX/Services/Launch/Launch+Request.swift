//
//  Launch+Request.swift
//  SpaceX
//
//  Created by David Beleza on 24/10/2021.
//

import Foundation

extension Launch {
    public struct Request: Encodable {
        let query: Query?
        let options: Options?
    }
}

// MARK: - 💻 Request Query
extension Launch.Request {
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

        public enum CodingKeys: String, CodingKey {
            case dateUtc = "date_utc"
            case success
        }

        let dateUtc: DateRange?
        let success: Bool?
    }
}

// MARK: - 🍱 Request Options
extension Launch.Request {
    public struct Options: Encodable {
        struct Populate: Encodable {
            var path = "rocket"
            var select = ["name", "type"]
        }

        let limit: Int?
        let offset: Int?
        var select = ["name", "date_unix", "links", "success"]
        var populate = Populate()
        let sort: String?
    }
}

// MARK: - ⚙️ Request Builder
extension Launch.Request {
    public class Builder {

        typealias DateRange = Query.DateRange

        private(set) var dateUtc: DateRange?
        private(set) var success: Bool?

        private(set) var limit: Int = 50
        private(set) var offset: Int = 0
        private(set) var sort: String?

        @discardableResult
        func setYear(year: String) -> Builder {
            self.dateUtc = DateRange(year: year)
            return self
        }

        @discardableResult
        func setSuccess(success: Bool) -> Builder {
            self.success = success
            return self
        }

        @discardableResult
        func setLimit(limit: Int) -> Builder {
            if limit > 0 { self.limit = limit }
            return self
        }

        @discardableResult
        func setOffset(offset: Int) -> Builder {
            if offset >= 0 { self.offset = offset }
            return self
        }

        @discardableResult
        func setLaunchDateSort(field: String = "date_utc", isAscending: Bool) -> Builder {
            self.sort = isAscending ? field : "-\(field)"
            return self
        }

        func build() -> Launch.Request {

            var query: Query? = nil
            if let dateUtc = dateUtc {
                query = Query(dateUtc: dateUtc, success: self.success)
            }

            let options = Options(limit: self.limit,
                                  offset: self.offset,
                                  sort: self.sort)

            return Launch.Request(query: query, options: options)
        }
    }
}
