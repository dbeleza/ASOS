//
//  LaunchDetailsInteractor.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

public protocol LaunchDetailsInteractor {
    func viewDidLoad()
}

public enum LaunchDetailsButtons: Hashable {
    case wikipedia
    case article
    case youtube
}

final class LaunchDetailsInteractorImpl {
    private let viewModel: Launch.ViewModel
    private let presenter: LaunchDetailsPresenter

    init(presenter: LaunchDetailsPresenter, viewModel: Launch.ViewModel) {
        self.viewModel = viewModel
        self.presenter = presenter
    }
}

extension LaunchDetailsInteractorImpl: LaunchDetailsInteractor {
    func viewDidLoad() {
        var model = [LaunchDetailsButtons: URL]()
        if let articleLink = viewModel.metadata.articleLink, let url = URL(string: articleLink) {
            model[.article] = url
        }

        if let wikipediaLink = viewModel.metadata.wikipediaLink, let url = URL(string: wikipediaLink) {
            model[.wikipedia] = url
        }

        if let youtubeLink = viewModel.metadata.youtubeLink, let url = URL(string: youtubeLink) {
            model[.youtube] = url
        }

        presenter.interactor(show: model)

        if let str = viewModel.metadata.smallThumbnail {
            presenter.interactor(showImage: str)
        }
    }
}
