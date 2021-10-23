//
//  LaunchListInteractor.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

public protocol LaunchListInteractor {
    func startListenReachability()
    func loadScreen()
    func fetchNextLaunches()
    func fetchCompanyDetails()
    func applyFilter(isSuccess: Bool, year: String, isAscending: Bool)
    func resetFilter()
    func didTapFilterButton()
}

final class LaunchListInteractorImpl {
    typealias Engine = HasLaunchService & HasCompanyService & HasReachabilityService
    private let engine: Engine
    private let presenter: LaunchListPresenter

    private let limit = 50
    private var offset = 0
    private var totalResults = 0
    private var isFetchingLaunches = false
    private var isFetchingCompany = false
    private var filterState: Filter.State?

    init(engine: Engine, presenter: LaunchListPresenter) {
        self.engine = engine
        self.presenter = presenter
    }
}

extension LaunchListInteractorImpl: LaunchListInteractor {
    func startListenReachability() {
        self.engine.reachabilityService.start { [weak self] isReachable in
            self?.presenter.interator(hasInternetConnection: isReachable)
        }
    }

    func loadScreen() {
        fetchCompanyDetails()
        fetchNextLaunches()
    }

    func fetchCompanyDetails() {
        guard !isFetchingCompany else { return }
        engine.companyService.fetchCompany { [weak self] result in
            self?.isFetchingCompany = false
            switch result {
            case .success(let response):
                self?.presenter.interator(didRetrieveCompany: response)

            case .failure:
                // TODO: Error handling must be improved
                self?.presenter.interatorDidRetrieveErrorCompany()
            }
        }
    }

    func fetchNextLaunches() {
        fetchNextLaunches(filterState)
    }

    @discardableResult
    private func fetchNextLaunches(_ filter: Filter.State?) -> Bool {
        guard offset <= totalResults, !isFetchingLaunches else { return false }
        isFetchingLaunches = true
        self.engine.launchService.fetchLaunches(limit: self.limit, offset: self.offset, filter: filter) { [weak self] result in
            guard let self = self else { return }
            self.isFetchingLaunches = false
            switch result {
            case .success(let response):
                self.offset += self.limit
                self.totalResults = response.totalResults
                self.presenter.interator(didRetrieveLaunches: response.list)

            case .failure:
                // TODO: Error handling must be improved
                self.presenter.interatorDidRetrieveErrorLaunches()
            }
        }
        return true
    }

    func applyFilter(isSuccess: Bool, year: String, isAscending: Bool) {
        let newFilter = Filter.State(isSuccess: isSuccess, selectedYear: year, isAscending: isAscending)
        if newFilter != filterState {
            offset = 0
            totalResults = 0
            presenter.interatorResetLaunchesList()
            if fetchNextLaunches(newFilter) {
                // If isFetchingLaunches == true and we try to apply a filter, we should only save filter if we really made the request
                // TODO: An information to the user should be sent informing that the filter was not applied
                filterState = newFilter
            }
        }
    }

    func resetFilter() {
        filterState = nil
        offset = 0
        totalResults = 0
        presenter.interatorResetLaunchesList()
        fetchNextLaunches()
    }

    func didTapFilterButton() {
        presenter.interactor(didRetrieveFilterState: filterState)
    }
}
