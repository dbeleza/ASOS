//
//  ViewController.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import UIKit

protocol LaunchListFilterOutput: AnyObject {
    func applyFilter(isFilterActive: Bool, year: String, sortOrder: Int)
}

class LaunchFilterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

