//
//  LaunchConfigurator.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

final class LaunchConfigurator {

    static func configureModule(viewController: LaunchListViewController) {
        let presenter = LaunchListPresenterImpl()
        presenter.viewController = viewController

        let engine = Engine()
        let interator = LaunchListInteractorImpl(engine: engine, presenter: presenter)

        let router = LaunchListRouterImpl()
        router.navigationController = viewController.navigationController
        viewController.interactor = interator
        viewController.router = router
    }

    static func configureModule(viewController: LaunchDetailsViewController, viewModel: Launch.ViewModel) {
        let presenter = LaunchDetailsPresenterImpl()
        presenter.viewController = viewController

        let interactor = LaunchDetailsInteractorImpl(presenter: presenter, viewModel: viewModel)

        let router = LaunchDetailsRouterImpl()
        viewController.interactor = interactor
        viewController.router = router
    }

    static func configureModule(viewController: LaunchFilterViewController, filterState: Filter.State?) {
        let presenter = LaunchFilterPresenterImpl()
        presenter.viewController = viewController

        let interactor = LaunchFilterInteractorImpl(presenter: presenter, filterState: filterState)

        let router = LaunchFilterRouterImpl()
        viewController.interactor = interactor
        viewController.router = router
    }
}
