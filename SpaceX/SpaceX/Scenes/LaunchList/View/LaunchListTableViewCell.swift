//
//  LaunchListTableViewCell.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import UIKit

final class LaunchListTableViewCell: UITableViewCell {
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var missionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.mission.localized
        label.textColor = UIColor.spaceDarkBlue
        label.font = SpaceXFont.heavy.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var missionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.spaceGray
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = SpaceXFont.medium.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var dateTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.dateTime.localized
        label.textColor = UIColor.spaceDarkBlue
        label.font = SpaceXFont.heavy.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.spaceGray
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = SpaceXFont.medium.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var rocketTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.rocket.localized
        label.textColor = UIColor.spaceDarkBlue
        label.font = SpaceXFont.heavy.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var rocketLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.spaceGray
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = SpaceXFont.medium.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var daysTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.spaceDarkBlue
        label.font = SpaceXFont.heavy.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var daysLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.spaceGray
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = SpaceXFont.medium.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var launchSuccessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    private var imageLoaderTask: URLSessionTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(missionTitleLabel)
        contentView.addSubview(missionLabel)
        contentView.addSubview(dateTimeTitleLabel)
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(rocketTitleLabel)
        contentView.addSubview(rocketLabel)
        contentView.addSubview(daysTitleLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(launchSuccessImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.UI.baseline * 2),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.UI.baseline * 2),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 50),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 50),

            launchSuccessImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.UI.baseline * 2),
            launchSuccessImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.UI.baseline * 2),
            launchSuccessImageView.heightAnchor.constraint(equalToConstant: 25),
            launchSuccessImageView.widthAnchor.constraint(equalToConstant: 25),

            missionTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: Constants.UI.baseline),
            missionTitleLabel.trailingAnchor.constraint(equalTo: missionLabel.leadingAnchor, constant: -Constants.UI.baseline),
            missionTitleLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),

            missionLabel.trailingAnchor.constraint(equalTo: launchSuccessImageView.leadingAnchor, constant: -Constants.UI.baseline),
            missionLabel.topAnchor.constraint(equalTo: missionTitleLabel.topAnchor),

            dateTimeTitleLabel.topAnchor.constraint(equalTo: missionLabel.bottomAnchor, constant: Constants.UI.baseline),
            dateTimeTitleLabel.leadingAnchor.constraint(equalTo: missionTitleLabel.leadingAnchor),
            dateTimeTitleLabel.trailingAnchor.constraint(equalTo: dateTimeLabel.leadingAnchor, constant: -Constants.UI.baseline),

            dateTimeLabel.topAnchor.constraint(equalTo: dateTimeTitleLabel.topAnchor),
            dateTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.UI.baseline * 2),

            rocketTitleLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: Constants.UI.baseline),
            rocketTitleLabel.leadingAnchor.constraint(equalTo: missionTitleLabel.leadingAnchor),
            rocketTitleLabel.trailingAnchor.constraint(equalTo: rocketLabel.leadingAnchor, constant: -Constants.UI.baseline),

            rocketLabel.topAnchor.constraint(equalTo: rocketTitleLabel.topAnchor),
            rocketLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.UI.baseline * 2),

            daysTitleLabel.topAnchor.constraint(equalTo: rocketTitleLabel.bottomAnchor, constant: Constants.UI.baseline),
            daysTitleLabel.leadingAnchor.constraint(equalTo: missionTitleLabel.leadingAnchor),
            daysTitleLabel.trailingAnchor.constraint(equalTo: daysLabel.leadingAnchor, constant: -Constants.UI.baseline),

            daysLabel.topAnchor.constraint(equalTo: daysTitleLabel.topAnchor),
            daysLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.UI.baseline * 2),

            contentView.bottomAnchor.constraint(equalTo: daysLabel.bottomAnchor, constant: Constants.UI.baseline)
        ])
    }

    func configure(_ viewModel: Launch.ViewModel) {
        if let thumbUrl = viewModel.metadata.smallThumbnail {
            imageLoaderTask = thumbnailImageView.loadRemoteImageFrom(urlString: thumbUrl, placeholder: UIImage(named: "noImage"))
        }
        missionLabel.text = viewModel.missionName
        dateTimeLabel.text = "\(viewModel.launchDate) \(LocalizedString.at.localized) \(viewModel.launchTime)"
        rocketLabel.text = "\(viewModel.rocket.name) / \(viewModel.rocket.type)"
        daysTitleLabel.text = viewModel.launchDaysTitle
        daysLabel.text = viewModel.launchDays != nil ? String(viewModel.launchDays!) : LocalizedString.notDefined.localized
        guard let launchSuccess = viewModel.launchSuccess else { return }
        launchSuccessImageView.image = launchSuccess ? UIImage(named: "checkmark") : UIImage(named: "redCross")
        launchSuccessImageView.isHidden = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        launchSuccessImageView.isHidden = true
        imageLoaderTask?.cancel()
        thumbnailImageView.image = UIImage(named: "noImage")
    }
}
