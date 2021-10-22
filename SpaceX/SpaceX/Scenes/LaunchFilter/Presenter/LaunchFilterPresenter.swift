//
//  LaunchFilterPresenter.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public protocol LaunchFilterPresenter {
    func interactor(retrieve years: [String], sortOptions: [Filter.SortOptions], filterState: Filter.State?)
}

final class LaunchFilterPresenterImpl: LaunchFilterPresenter {
    weak var viewController: LaunchFilterPresenterOutput?

    func interactor(retrieve years: [String], sortOptions: [Filter.SortOptions], filterState: Filter.State?) {

        let yearIndex = years.firstIndex(where: { $0 == (filterState?.selectedYear ?? DateFormatter.getYearFromDate(Date())) }) ?? 0
        let viewModel = Filter.ViewModel(years: years,
                                         sortOptions: sortOptions,
                                         isFilterOn: filterState?.isFilterOn ?? false,
                                         preselectYearIndex: yearIndex,
                                         preselectSortIndex: filterState?.selectedSortOrderIndex ?? 0)
        viewController?.presenter(didRetrievePickerModel: viewModel)
    }
}
