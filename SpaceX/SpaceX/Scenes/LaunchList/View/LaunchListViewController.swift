//
//  LaunchListViewController.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import UIKit

protocol LaunchListPresenterOutput: AnyObject {
    func presenter(didRetrieveCompany company: Company.ViewModel)
    func presenter(didRetrieveCompanyError errorStr: String)

    func presenter(didRetrieveLaunchList launches: [Launch.ViewModel])
    func presenter(didRetrieveLaunchListError errorStr: String)

    func presenter(hasInternetConnection: Bool)

    func presenterResetLaunchesList()

    func presenter(openFilterWith filter: Filter.State?)
}

protocol LaunchListFilterOutput: AnyObject {
    func applyFilter(isLaunchSuccess: Bool, year: String, isAscending: Bool)
    func resetFilter()
}

final class LaunchListViewController: BaseViewController {

    var interactor: LaunchListInteractor?
    var router: LaunchListRouter?

    private let launchCellId = "launchId"
    private let companyCellId = "companyCellId"
    private var viewDidAppear = false

    private enum Section: Int, CaseIterable {
        case company
        case launches
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LaunchListTableViewCell.self, forCellReuseIdentifier: launchCellId)
        tableView.register(LaunchCompanyTableViewCell.self, forCellReuseIdentifier: companyCellId)
        tableView.sectionHeaderHeight = Constants.UI.baseline * 5
        tableView.rowHeight = UITableView.automaticDimension
        tableView.accessibilityIdentifier = Accessibility.Screen.Launch.tableView
        return tableView
    }()

    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.accessibilityIdentifier = Accessibility.Screen.Launch.spinner
        return spinner
    }()

    private var isSpinnerHidden: Bool {
        set {
            if newValue {
                spinner.stopAnimating()
            } else {
                spinner.startAnimating()
            }
            spinner.isHidden = newValue
            tableView.isHidden = !newValue
        }
        get {
            spinner.isHidden
        }
    }

    private var launchesDataSource = [Launch.ViewModel]() {
        didSet {
            if companyViewModel != nil {
                isSpinnerHidden = true
            }
        }
    }
    private var companyViewModel: Company.ViewModel? {
        didSet {
            if !launchesDataSource.isEmpty {
                isSpinnerHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        interactor?.startListenReachability()
        interactor?.loadScreen()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !viewDidAppear else { return }
        viewDidAppear = true
    }

    override func setupSubviews() {
        super.setupSubviews()

        tableView.isHidden = true
        spinner.startAnimating()

        view.addSubview(spinner)
        view.addSubview(tableView)
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizedString.sort.localized, style: .plain, target: self, action: #selector(didTapFilter))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = Accessibility.Screen.Launch.filterButton

        navigationItem.rightBarButtonItem?.tintColor = UIColor.spaceDarkBlue

        navigationItem.titleView = UIImageView(image: UIImage(named: "logo"))
    }

    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func didTapFilter() {
        interactor?.didTapFilterButton()
    }

    private func showNoResultsAlert() {
        let alert = UIAlertController(title: nil, message: LocalizedString.noResults.localized, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: LocalizedString.ok.localized, style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}

// MARK: - LaunchListPresenterOutput
extension LaunchListViewController: LaunchListPresenterOutput {
    func presenter(hasInternetConnection: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = hasInternetConnection

        if hasInternetConnection {
            dismissNoInternetBanner()
        } else {
            presentNoInternetBanner()
        }
    }

    // 🏦 Company
    func presenter(didRetrieveCompanyError errorStr: String) {
        let alert = UIAlertController(title: LocalizedString.errorTitle.localized, message: errorStr, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: LocalizedString.retry.localized, style: .default, handler: { [weak self] _ in
            self?.interactor?.fetchCompanyDetails()
        }))
        alert.addAction(UIAlertAction(title: LocalizedString.ok.localized, style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    func presenter(didRetrieveCompany company: Company.ViewModel) {
        companyViewModel = company
        tableView.reloadSections(IndexSet(integer: Section.company.rawValue), with: .automatic)
    }

    // 🚀 Launches
    func presenter(didRetrieveLaunchListError errorStr: String) {
        let alert = UIAlertController(title: LocalizedString.errorTitle.localized, message: errorStr, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: LocalizedString.retry.localized, style: .default, handler: { [weak self] _ in
            self?.interactor?.fetchNextLaunches()
        }))
        alert.addAction(UIAlertAction(title: LocalizedString.ok.localized, style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    func presenter(didRetrieveLaunchList launches: [Launch.ViewModel]) {
        self.launchesDataSource.append(contentsOf: launches)
        tableView.reloadSections(IndexSet(integer: Section.launches.rawValue), with: .fade)
        if launchesDataSource.isEmpty {
            showNoResultsAlert()
        }
    }

    func presenterResetLaunchesList() {
        self.launchesDataSource.removeAll()
        tableView.reloadSections(IndexSet(integer: Section.launches.rawValue), with: .fade)
    }

    func presenter(openFilterWith filter: Filter.State?) {
        router?.routeToFilter(filterState: filter, delegate: self)
    }
}

// MARK: - UITableViewDataSource
extension LaunchListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.company.rawValue:
            return 1

        case Section.launches.rawValue:
            return launchesDataSource.count

        default:
            fatalError("Section out of bounds 💩")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.company.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: companyCellId) as? LaunchCompanyTableViewCell else {
                fatalError("Expected to have a cell type: LaunchListTableViewCell 💩")
            }
            cell.selectionStyle = .none
            cell.configure(companyViewModel)
            return cell

        case Section.launches.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: launchCellId) as? LaunchListTableViewCell else {
                fatalError("Expected to have a cell type: LaunchListTableViewCell 💩")
            }
            cell.selectionStyle = .none
            cell.configure(launchesDataSource[indexPath.row])
            return cell

        default: fatalError("Section out of bounds 💩")
        }
    }
}

// MARK: - UITableViewDelegate
extension LaunchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.company.rawValue:
            return LocalizedString.company.localized

        case Section.launches.rawValue:
            return LocalizedString.launches.localized

        default:
            fatalError("Section out of bounds 💩")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToDetail(viewModel: launchesDataSource[indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewDidAppear else { return }
        let offsetY = tableView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 1.5 {
            interactor?.fetchNextLaunches()
        }
    }
}

// MARK: - LaunchListFilterOutput
extension LaunchListViewController: LaunchListFilterOutput {
    func applyFilter(isLaunchSuccess: Bool, year: String, isAscending: Bool) {
        interactor?.applyFilter(isSuccess: isLaunchSuccess, year: year, isAscending: isAscending)
    }

    func resetFilter() {
        interactor?.resetFilter()
    }
}

