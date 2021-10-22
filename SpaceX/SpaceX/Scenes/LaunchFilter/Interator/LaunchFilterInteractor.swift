//
//  LaunchFilterInteractor.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public protocol LaunchFilterInteractor {
    func retrievePickerModel()
}

final class LaunchFilterInteractorImpl: LaunchFilterInteractor {
    private let presenter: LaunchFilterPresenter
    private let filterState: Filter.State?

    init(presenter: LaunchFilterPresenter, filterState: Filter.State?) {
        self.presenter = presenter
        self.filterState = filterState
    }

    func retrievePickerModel() {
        let yearsInt = Array(1980...2030)
        let yearsString = yearsInt.map({ String($0) })

        let sortOptions = [Filter.SortOptions.asc, Filter.SortOptions.desc]

        presenter.interactor(retrieve: yearsString, sortOptions: sortOptions, filterState: filterState)
    }
}
