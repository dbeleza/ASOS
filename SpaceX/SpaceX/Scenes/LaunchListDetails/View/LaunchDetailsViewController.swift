//
//  LaunchDetailsViewController.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import UIKit

public protocol LaunchDetailsPresenterOutput: AnyObject {
    func presenter(show buttons: [LaunchDetailsButtons: URL])
    func presenter(showImage: String)
}

final class LaunchDetailsViewController: BaseViewController {
    var interactor: LaunchDetailsInteractor?
    var router: LaunchDetailsRouter?
    private var buttonActions: [LaunchDetailsButtons: URL]?

    private var logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "logo"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = Constants.UI.baseline * 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.articleDetailDescription.localized
        label.font = SpaceXFont.heavy.of(size: .small)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.spaceDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.noDetails.localized
        label.font = SpaceXFont.heavy.of(size: .small)
        label.textAlignment = .center
        label.textColor = UIColor.spaceDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private var articleButton: UIButton = {
        let button = UIButton.createSpaceXButton(title: LocalizedString.article.localized)
        button.addTarget(self, action: #selector(tapArticleButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var wikipediaButton: UIButton = {
        let button = UIButton.createSpaceXButton(title: LocalizedString.wikipedia.localized)
        button.addTarget(self, action: #selector(tapWikipediaButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var youtubeButton: UIButton = {
        let button = UIButton.createSpaceXButton(title: LocalizedString.youtube.localized)
        button.addTarget(self, action: #selector(tapYoutubeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        interactor?.viewDidLoad()
    }

    private func setupNavigationController() {
        let yourBackImage = UIImage(systemName: "chevron.left.circle.fill")
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationController?.navigationBar.tintColor = UIColor.spaceGray
    }

    override func setupSubviews() {
        super.setupSubviews()
        articleButton.isHidden = true
        wikipediaButton.isHidden = true
        youtubeButton.isHidden = true

        view.addSubview(logoImage)
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(noResultsLabel)

        buttonsStackView.addArrangedSubview(articleButton)
        buttonsStackView.addArrangedSubview(wikipediaButton)
        buttonsStackView.addArrangedSubview(youtubeButton)
        view.addSubview(buttonsStackView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.UI.baseline * 2),
            logoImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.UI.baseline * 2),
            logoImage.heightAnchor.constraint(equalToConstant: Constants.UI.baseline * 10),

            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: Constants.UI.baseline * 4),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.UI.baseline * 3),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.baseline * 3),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.UI.baseline * 3),

            buttonsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.UI.baseline * 2),
            buttonsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.UI.baseline * 2),
            buttonsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.UI.baseline * 2),

            wikipediaButton.heightAnchor.constraint(equalToConstant: Constants.UI.baseline * 4),
            articleButton.heightAnchor.constraint(equalTo: wikipediaButton.heightAnchor),
            youtubeButton.heightAnchor.constraint(equalTo: wikipediaButton.heightAnchor),

            wikipediaButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            articleButton.widthAnchor.constraint(equalTo: wikipediaButton.widthAnchor),
            youtubeButton.widthAnchor.constraint(equalTo: wikipediaButton.widthAnchor),

            noResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.baseline * 3),
            noResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.UI.baseline * 3),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func tapArticleButton() {
        guard let buttons = buttonActions, let url = buttons[.article] else {
            return
        }
        router?.openBrowser(url: url)
    }

    @objc private func tapWikipediaButton() {
        guard let buttons = buttonActions, let url = buttons[.wikipedia] else {
            return
        }
        router?.openBrowser(url: url)
    }

    @objc private func tapYoutubeButton() {
        guard let buttons = buttonActions, let url = buttons[.youtube] else {
            return
        }
        router?.openBrowser(url: url)
    }
}

extension LaunchDetailsViewController: LaunchDetailsPresenterOutput {
    func presenter(show buttons: [LaunchDetailsButtons: URL]) {
        self.buttonActions = buttons
        buttons.forEach { key, _ in
            switch key {
            case .youtube:
                youtubeButton.isHidden = false
            case .wikipedia:
                wikipediaButton.isHidden = false
            case .article:
                articleButton.isHidden = false
            }
        }

        let hasNoResults = youtubeButton.isHidden && wikipediaButton.isHidden && articleButton.isHidden
        noResultsLabel.isHidden = !hasNoResults
        imageView.isHidden = hasNoResults
        buttonsStackView.isHidden = hasNoResults
        descriptionLabel.isHidden = hasNoResults
    }

    func presenter(showImage url: String) {
        imageView.loadRemoteImageFrom(urlString: url, placeholder: UIImage(named: "noImage"))
    }
}
