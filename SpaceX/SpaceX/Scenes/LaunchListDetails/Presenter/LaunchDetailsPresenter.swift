//
//  LaunchDetailsPresenter.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

public protocol LaunchDetailsPresenter {
    func interactor(show buttons: [LaunchDetailsButtons: URL])
    func interactor(showImage: String)
}

final class LaunchDetailsPresenterImpl: LaunchDetailsPresenter {
    weak var viewController: LaunchDetailsPresenterOutput?

    func interactor(show buttons: [LaunchDetailsButtons: URL]) {
        viewController?.presenter(show: buttons)
    }

    func interactor(showImage: String) {
        viewController?.presenter(showImage: showImage)
    }
}
