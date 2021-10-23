//
//  LaunchListPresenter.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

protocol LaunchListPresenter {
    func interator(didRetrieveCompany company: Company.Response)
    func interatorDidRetrieveErrorCompany()

    func interator(didRetrieveLaunches launches: [Launch.ListResponse.Response])
    func interatorDidRetrieveErrorLaunches()

    func interator(hasInternetConnection: Bool)
    func interatorResetLaunchesList()

    func interactor(didRetrieveFilterState filter: Filter.State?)
}

final class LaunchListPresenterImpl: LaunchListPresenter {

    weak var viewController: LaunchListPresenterOutput?

    func interator(didRetrieveCompany company: Company.Response) {
        let companyViewModel = Company.ViewModel(company: company)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.presenter(didRetrieveCompany: companyViewModel)
        }
    }

    func interator(didRetrieveLaunches launches: [Launch.ListResponse.Response]) {
        let viewModelList: [Launch.ViewModel] = launches.map { response in
            let metadata = Launch.ViewModel.Metadata(smallThumbnail: response.metadata.images?.small,
                                                     bigThumbnail: response.metadata.images?.large,
                                                     articleLink: response.metadata.articleLink,
                                                     wikipediaLink: response.metadata.wikipediaLink,
                                                     youtubeLink: response.metadata.youtubeLink)

            let rocket = Launch.ViewModel.Rocket(name: response.rocket.name,
                                                 type: response.rocket.type)

            var launchDaysTitle: String?
            let differenceOfDays = response.launchDateUnix.differenceBetweenDate(Date())
            if let days = differenceOfDays {
                launchDaysTitle = days < 0 ? LocalizedString.daysSince.localized : LocalizedString.daysFrom.localized
            }

            return Launch.ViewModel(id: response.id,
                                    missionName: response.missionName,
                                    launchDate: response.launchDateUnix.convertUnixToDateString(),
                                    launchTime: response.launchDateUnix.convertUnixToTimeString(),
                                    launchSuccess: response.launchSuccess,
                                    launchDays: differenceOfDays,
                                    launchDaysTitle: launchDaysTitle,
                                    metadata: metadata,
                                    rocket: rocket)
        }
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.presenter(didRetrieveLaunchList: viewModelList)
        }
    }

    func interator(hasInternetConnection: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.presenter(hasInternetConnection: hasInternetConnection)
        }
    }

    func interatorDidRetrieveErrorCompany() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.presenter(didRetrieveCompanyError: LocalizedString.error.localized)
        }
    }

    func interatorDidRetrieveErrorLaunches() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.presenter(didRetrieveLaunchListError: LocalizedString.error.localized)
        }
    }

    func interatorResetLaunchesList() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.presenterResetLaunchesList()
        }
    }

    func interactor(didRetrieveFilterState filter: Filter.State?) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.presenter(openFilterWith: filter)
        }
    }
}
