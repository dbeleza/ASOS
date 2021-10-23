//
//  LaunchListViewControllerMock.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
@testable import SpaceX

final class LaunchListViewControllerMock: LaunchListPresenterOutput {

    enum Event: Equatable {
        static func == (lhs: LaunchListViewControllerMock.Event, rhs: LaunchListViewControllerMock.Event) -> Bool {
            switch (lhs, rhs) {
            case (.didRetrieveCompany(let viewModelA), .didRetrieveCompany(let viewModelB)):
                return viewModelA == viewModelB
            case (.didRetrieveLaunchList(let viewModelA), .didRetrieveLaunchList(let viewModelB)):
                return viewModelA == viewModelB
            case (.didRetrieveCompanyError(let strA), .didRetrieveCompanyError(let strB)):
                return strA == strB
            case (.didRetrieveLaunchListError(let strA), .didRetrieveLaunchListError(let strB)):
                return strA == strB
            case (.hasInternetConnection(let valueA), .hasInternetConnection(let valueB)):
                return valueA == valueB
            case (.didResetLaunchesList, .didResetLaunchesList):
                return true
            case (.didOpenFilter(let modelA), .didOpenFilter(let modelB)):
                return modelA == modelB
            default:
                return false
            }
        }

        case didRetrieveCompany(Company.ViewModel)
        case didRetrieveCompanyError(String)
        case didRetrieveLaunchList([Launch.ViewModel])
        case didRetrieveLaunchListError(String)
        case hasInternetConnection(Bool)
        case didResetLaunchesList
        case didOpenFilter(Filter.State?)
    }

    var log: [Event] = []

    func presenter(didRetrieveCompany company: Company.ViewModel) {
        log.append(.didRetrieveCompany(company))
    }

    func presenter(didRetrieveCompanyError errorStr: String) {
        log.append(.didRetrieveCompanyError(errorStr))
    }

    func presenter(didRetrieveLaunchList launches: [Launch.ViewModel]) {
        log.append(.didRetrieveLaunchList(launches))
    }

    func presenter(didRetrieveLaunchListError errorStr: String) {
        log.append(.didRetrieveLaunchListError(errorStr))
    }

    func presenter(hasInternetConnection: Bool) {
        log.append(.hasInternetConnection(hasInternetConnection))
    }

    func presenterResetLaunchesList() {
        log.append(.didResetLaunchesList)
    }

    func presenter(openFilterWith filter: Filter.State?) {
        log.append(.didOpenFilter(filter))
    }
}
