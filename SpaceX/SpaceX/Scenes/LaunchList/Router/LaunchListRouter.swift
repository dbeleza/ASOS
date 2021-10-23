//
//  LaunchListRouter.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
import UIKit

protocol LaunchListRouter {
    var navigationController: UINavigationController? { get }
    func routeToDetail(viewModel: Launch.ViewModel)
    func routeToFilter(filterState: Filter.State?, delegate: LaunchListFilterOutput)
}

final class LaunchListRouterImpl: LaunchListRouter {
    weak var navigationController: UINavigationController?

    func routeToDetail(viewModel: Launch.ViewModel) {
        let viewController = LaunchDetailsViewController()
        LaunchConfigurator.configureModule(viewController: viewController, viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func routeToFilter(filterState: Filter.State?, delegate: LaunchListFilterOutput) {
        let viewController = LaunchFilterViewController(delegate: delegate)
        LaunchConfigurator.configureModule(viewController: viewController, filterState: filterState)
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}
