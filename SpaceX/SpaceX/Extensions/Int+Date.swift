//
//  Int+Date.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

extension Int {
    func convertUnixToDateString() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return DateFormatter.shortDate.string(from: date)
    }

    func convertUnixToTimeString() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return DateFormatter.shortTime.string(from: date)
    }

    func differenceBetweenDate(_ senderDate: Date) -> Int? {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let numberOfDays = Calendar.current.dateComponents([.day], from: senderDate, to: date)
        return numberOfDays.day
    }
}
