//
//  LaunchFilterPresenter.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public protocol LaunchFilterPresenter {
    func interactor(retrieve years: [String], filterState: Filter.State?)
}

final class LaunchFilterPresenterImpl: LaunchFilterPresenter {
    weak var viewController: LaunchFilterPresenterOutput?

    func interactor(retrieve years: [String], filterState: Filter.State?) {

        let yearIndex = years.firstIndex(where: { $0 == (filterState?.selectedYear ?? DateFormatter.getYearFromDate(Date())) }) ?? 0
        let viewModel = Filter.ViewModel(years: years,
                                         isAscending: filterState?.isAscending ?? true,
                                         isSuccess: filterState?.isSuccess ?? true,
                                         preselectYearIndex: yearIndex)
        viewController?.presenter(didRetrievePickerModel: viewModel)
    }
}
