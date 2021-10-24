//
//  LaunchFilterViewController.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import UIKit

public protocol LaunchFilterPresenterOutput: AnyObject {
    func presenter(didRetrievePickerModel: Filter.ViewModel)
}

final class LaunchFilterViewController: BaseViewController {
    weak var delegate: LaunchListFilterOutput?

    var interactor: LaunchFilterInteractor?
    var router: LaunchFilterRouter?

    private enum LaunchType: Int {
        case failure
        case success

        init(rawValue: Int) {
            switch rawValue {
            case Self.failure.rawValue:
                self = .failure

            case Self.success.rawValue:
                self = .success

            default:
                self = .success
            }
        }

        var text: String {
            switch self {
            case .failure:
                return LocalizedString.filterFailure.localized
            case .success:
                return LocalizedString.filterSuccess.localized
            }
        }
    }

    private enum YearSort: Int {
        case descending
        case ascending

        init(rawValue: Int) {
            switch rawValue {
            case Self.descending.rawValue:
                self = .descending

            case Self.ascending.rawValue:
                self = .ascending

            default:
                self = .ascending
            }
        }

        var text: String {
            switch self {
            case .descending:
                return LocalizedString.filterDescending.localized
            case .ascending:
                return LocalizedString.filterAscending.localized
            }
        }
    }

    private var pickerViewModel: Filter.ViewModel?

    private var successSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.launchSuccess.localized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.spaceDarkBlue
        label.font = SpaceXFont.heavy.of(size: .small)
        return label
    }()

    private lazy var launchTypeSegmentedControl: UISegmentedControl = {
        let switcher = UISegmentedControl(items: [LaunchType.failure.text, LaunchType.success.text])
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()

    private var sortSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.sortBy.localized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.spaceDarkBlue
        label.font = SpaceXFont.heavy.of(size: .small)
        return label
    }()

    private lazy var sortYearSegmentedControl: UISegmentedControl = {
        let switcher = UISegmentedControl(items: [YearSort.descending.text, YearSort.ascending.text])
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()

    private var filterDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.filterDescription.localized
        label.font = SpaceXFont.heavy.of(size: .small)
        label.textColor = UIColor.spaceDarkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.accessibilityIdentifier = Accessibility.Screen.Filter.pickerView
        return picker
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton.primarySpaceXButton(title: LocalizedString.save.localized)
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var resetButton: UIButton = {
        let button = UIButton.primarySpaceXButton(title: LocalizedString.reset.localized)
        button.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton.secondarySpaceXButton(title: LocalizedString.close.localized)
        button.backgroundColor = UIColor.spaceGray
        button.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(delegate: LaunchListFilterOutput) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.retrievePickerModel()
    }

    override func setupSubviews() {
        super.setupSubviews()

        view.addSubview(successSwitchLabel)
        view.addSubview(launchTypeSegmentedControl)
        view.addSubview(sortSwitchLabel)
        view.addSubview(sortYearSegmentedControl)
        view.addSubview(filterDescriptionLabel)
        view.addSubview(pickerView)
        view.addSubview(saveButton)
        view.addSubview(resetButton)
        view.addSubview(dismissButton)
    }

    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([
            filterDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.UI.baseline * 5),
            filterDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.UI.baseline * 5),
            filterDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.UI.baseline * 5),

            pickerView.topAnchor.constraint(equalTo: filterDescriptionLabel.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200),

            successSwitchLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.UI.baseline * 5),
            successSwitchLabel.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: Constants.UI.baseline * 3),

            launchTypeSegmentedControl.centerYAnchor.constraint(equalTo: successSwitchLabel.centerYAnchor),
            launchTypeSegmentedControl.leftAnchor.constraint(equalTo: successSwitchLabel.rightAnchor, constant: Constants.UI.baseline),

            sortSwitchLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.UI.baseline * 5),
            sortSwitchLabel.topAnchor.constraint(equalTo: successSwitchLabel.bottomAnchor, constant: Constants.UI.baseline * 4),

            sortYearSegmentedControl.centerYAnchor.constraint(equalTo: sortSwitchLabel.centerYAnchor),
            sortYearSegmentedControl.leftAnchor.constraint(equalTo: sortSwitchLabel.rightAnchor, constant: Constants.UI.baseline),

            saveButton.heightAnchor.constraint(equalToConstant: Constants.UI.baseline * 4),
            saveButton.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -Constants.UI.baseline * 2),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            resetButton.heightAnchor.constraint(equalToConstant: Constants.UI.baseline * 4),
            resetButton.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -Constants.UI.baseline * 4),
            resetButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dismissButton.heightAnchor.constraint(equalToConstant: Constants.UI.baseline * 4),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.UI.baseline * 4),
            dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapSave() {
        guard let viewModel = pickerViewModel else { return }
        let yearRow = pickerView.selectedRow(inComponent: .zero)
        let year = viewModel.years[yearRow]
        let isSuccessLaunch = LaunchType(rawValue: launchTypeSegmentedControl.selectedSegmentIndex) == .success
        let isAscending = YearSort(rawValue: sortYearSegmentedControl.selectedSegmentIndex) == .ascending

        delegate?.applyFilter(isLaunchSuccess: isSuccessLaunch, year: year, isAscending: isAscending)
        router?.dismiss(viewController: self)
    }

    @objc private func didTapDismiss() {
        router?.dismiss(viewController: self)
    }

    @objc private func didTapReset() {
        delegate?.resetFilter()
        router?.dismiss(viewController: self)
    }
}

// MARK: - UIPickerViewDelegate
extension LaunchFilterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = pickerViewModel else { return nil }
        return viewModel.years[row]
    }
}

// MARK: - UIPickerViewDataSource
extension LaunchFilterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = pickerViewModel else { return 0 }
        return viewModel.years.count
    }
}

// MARK: - LaunchFilterPresenterOutput
extension LaunchFilterViewController: LaunchFilterPresenterOutput {
    func presenter(didRetrievePickerModel viewModel: Filter.ViewModel) {
        pickerViewModel = viewModel
        pickerView.reloadAllComponents()
        launchTypeSegmentedControl.selectedSegmentIndex = viewModel.isSuccess ? LaunchType.success.rawValue : LaunchType.failure.rawValue
        sortYearSegmentedControl.selectedSegmentIndex = viewModel.isAscending ? YearSort.ascending.rawValue : YearSort.descending.rawValue
        pickerView.selectRow(viewModel.preselectYearIndex, inComponent: .zero, animated: false)
    }
}
