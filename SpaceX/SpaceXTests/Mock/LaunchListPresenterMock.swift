//
//  LaunchListPresenterMock.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
@testable import SpaceX

final class LaunchListPresenterMock: LaunchListPresenter {

    enum Event: Equatable {
        static func == (lhs: LaunchListPresenterMock.Event, rhs: LaunchListPresenterMock.Event) -> Bool {
            switch (lhs, rhs) {
            case (.didRetrieveCompany(let modelA), .didRetrieveCompany(let modelB)):
                return modelA == modelB
            case (.didRetrieveErrorCompany, .didRetrieveErrorCompany):
                return true
            case (.didRetrieveLaunches(let modelA), .didRetrieveLaunches(let modelB)):
                return modelA == modelB
            case (.didRetrieveErrorLaunches, .didRetrieveErrorLaunches):
                return true
            case (.hasInternetConnection, .hasInternetConnection):
                return true
            case (.didResetLaunchesList, didResetLaunchesList):
                return true
            case (.didRetrieveFilterState(let modelA), .didRetrieveFilterState(let modelB)):
                return modelA == modelB
            default:
                return false
            }
        }

        case didRetrieveCompany(Company.Response)
        case didRetrieveErrorCompany
        case didRetrieveLaunches([Launch.ListResponse.Response])
        case didRetrieveErrorLaunches
        case hasInternetConnection
        case didResetLaunchesList
        case didRetrieveFilterState(Filter.State?)
    }

    var log: [Event] = []

    func interator(didRetrieveCompany company: Company.Response) {
        log.append(.didRetrieveCompany(company))
    }

    func interatorDidRetrieveErrorCompany() {
        log.append(.didRetrieveErrorCompany)
    }

    func interator(didRetrieveLaunches launches: [Launch.ListResponse.Response]) {
        log.append(.didRetrieveLaunches(launches))
    }

    func interatorDidRetrieveErrorLaunches() {
        log.append(.didRetrieveErrorLaunches)
    }

    func interator(hasInternetConnection: Bool) {
        log.append(.hasInternetConnection)
    }

    func interatorResetLaunchesList() {
        log.append(.didResetLaunchesList)
    }

    func interactor(didRetrieveFilterState filter: Filter.State?) {
        log.append(.didRetrieveFilterState(filter))
    }

    func clearLog() {
        log.removeAll()
    }
}
