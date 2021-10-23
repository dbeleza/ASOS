//
//  BaseViewController.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    private lazy var networkBanner: NetworkBannerView = {
        let view = NetworkBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var networkBannerBottomConstraint: NSLayoutConstraint!
    private let networkBannerHeight = Constants.UI.baseline * 5

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupConstraints()
    }

    func setupSubviews() {
        view.backgroundColor = UIColor.spaceWhite
        networkBanner.isHidden = true
        view.addSubview(networkBanner)
    }

    func setupConstraints() {
        // Override
        networkBannerBottomConstraint = networkBanner.topAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            networkBanner.leftAnchor.constraint(equalTo: view.leftAnchor),
            networkBanner.rightAnchor.constraint(equalTo: view.rightAnchor),
            networkBanner.heightAnchor.constraint(equalToConstant: networkBannerHeight),
            networkBannerBottomConstraint
        ])
    }

    func presentNoInternetBanner() {
        guard networkBanner.isHidden else { return }
        networkBanner.isHidden = false
        view.bringSubviewToFront(networkBanner)
        networkBannerBottomConstraint.constant = -networkBannerHeight
        UIView.animate(withDuration: Constants.Animation.short) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func dismissNoInternetBanner() {
        guard !networkBanner.isHidden else { return }
        networkBannerBottomConstraint.constant = networkBannerHeight
        UIView.animate(withDuration: Constants.Animation.short) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.networkBanner.isHidden = true
        }
    }
}
