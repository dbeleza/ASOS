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

    private var pickerViewModel: Filter.ViewModel?

    private var switchLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.filterState.localized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.spaceDarkBlue
        label.font = SpaceXFont.heavy.of(size: .small)
        return label
    }()

    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
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

    private var filterNoteLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.filterNote.localized
        label.font = SpaceXFont.medium.of(size: .extraSmall)
        label.textColor = UIColor.spaceGray
        label.numberOfLines = 3
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    enum PickerComponents: Int, CaseIterable {
        case years
        case sortOption
    }
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton.createSpaceXButton(title: LocalizedString.save.localized)
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton.createSpaceXButton(title: LocalizedString.close.localized)
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

        view.addSubview(switchLabel)
        view.addSubview(switcher)
        view.addSubview(filterDescriptionLabel)
        view.addSubview(pickerView)
        view.addSubview(filterNoteLabel)
        view.addSubview(saveButton)
        view.addSubview(dismissButton)
    }

    override func setupConstraints() {
        super.setupConstraints()

        NSLayoutConstraint.activate([
            switchLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.Margin.baseline * 5),
            switchLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Margin.baseline * 5),

            switcher.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),
            switcher.leftAnchor.constraint(equalTo: switchLabel.rightAnchor, constant: Constants.Margin.baseline),

            filterDescriptionLabel.topAnchor.constraint(equalTo: switcher.bottomAnchor, constant: Constants.Margin.baseline * 6),
            filterDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Margin.baseline * 5),
            filterDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Margin.baseline * 5),

            pickerView.topAnchor.constraint(equalTo: filterDescriptionLabel.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200),

            filterNoteLabel.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: Constants.Margin.baseline * 2),
            filterNoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Margin.baseline * 5),
            filterNoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Margin.baseline * 5),

            saveButton.heightAnchor.constraint(equalToConstant: Constants.Margin.baseline * 4),
            saveButton.bottomAnchor.constraint(equalTo: dismissButton.topAnchor, constant: -Constants.Margin.baseline * 2),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            dismissButton.heightAnchor.constraint(equalToConstant: Constants.Margin.baseline * 4),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Margin.baseline * 4),
            dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapSave() {
        guard let viewModel = pickerViewModel else { return }
        let yearRow = pickerView.selectedRow(inComponent: PickerComponents.years.rawValue)
        let year = viewModel.years[yearRow]

        let sortIndex = pickerView.selectedRow(inComponent: PickerComponents.sortOption.rawValue)

        delegate?.applyFilter(isFilterActive: switcher.isOn, year: year, sortOrder: sortIndex)
        router?.dismiss(viewController: self)
    }

    @objc private func didTapDismiss() {
        router?.dismiss(viewController: self)
    }
}

// MARK: - UIPickerViewDelegate
extension LaunchFilterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewModel = pickerViewModel else { return nil }
        switch component {
        case PickerComponents.years.rawValue:
            return viewModel.years[row]

        case PickerComponents.sortOption.rawValue:
            guard let sortOption = Filter.SortOptions(rawValue: row) else { return nil }
            return sortOption.string

        default:
            fatalError("Not expected to have more picker components 💩")
        }
    }
}

// MARK: - UIPickerViewDataSource
extension LaunchFilterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PickerComponents.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let viewModel = pickerViewModel else { return 0 }

        switch component {
        case PickerComponents.years.rawValue:
            return viewModel.years.count

        case PickerComponents.sortOption.rawValue:
            return viewModel.sortOptions.count

        default:
            fatalError("Not expected to have more picker components 💩")
        }
    }
}

// MARK: - LaunchFilterPresenterOutput
extension LaunchFilterViewController: LaunchFilterPresenterOutput {
    func presenter(didRetrievePickerModel viewModel: Filter.ViewModel) {
        pickerViewModel = viewModel
        pickerView.reloadAllComponents()
        switcher.isOn = viewModel.isFilterOn
        pickerView.selectRow(viewModel.preselectYearIndex, inComponent: PickerComponents.years.rawValue, animated: false)
        pickerView.selectRow(viewModel.preselectSortIndex, inComponent: PickerComponents.sortOption.rawValue, animated: false)
    }
}
