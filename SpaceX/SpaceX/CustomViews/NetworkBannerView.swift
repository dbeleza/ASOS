//
//  NetworkBannerView.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import UIKit

final class NetworkBannerView: UIView {
    private var internetLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.spaceWhite
        label.textAlignment = .center
        label.font = SpaceXFont.medium.of(size: .extraSmall)
        label.text = LocalizedString.noInternet.localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        backgroundColor = UIColor.spaceRed
        addSubview(internetLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            internetLabel.leftAnchor.constraint(equalTo: leftAnchor),
            internetLabel.rightAnchor.constraint(equalTo: rightAnchor),
            internetLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.UI.baseline),
        ])
    }
}
