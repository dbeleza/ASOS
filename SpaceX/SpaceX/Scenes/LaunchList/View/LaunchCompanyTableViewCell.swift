//
//  LaunchCompanyTableViewCell.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import UIKit

final class LaunchCompanyTableViewCell: UITableViewCell {
    private var companyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.companyDescription.localized
        label.textColor = UIColor.spaceGray
        label.numberOfLines = 0
        label.font = SpaceXFont.medium.of(size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(companyDescriptionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            companyDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.UI.baseline * 2),
            companyDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.UI.baseline * 2),
            companyDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.UI.baseline * 2),
            companyDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.UI.baseline * 2)
        ])
    }

    func configure(_ company: Company.ViewModel?) {
        guard let company = company else {
            companyDescriptionLabel.isHidden = true
            return
        }
        companyDescriptionLabel.text = company.text
        companyDescriptionLabel.isHidden = false
    }
}
