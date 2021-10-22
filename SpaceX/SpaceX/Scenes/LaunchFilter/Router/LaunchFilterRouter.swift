//
//  LaunchFilterRouter.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation
import UIKit

public protocol LaunchFilterRouter {
    func dismiss(viewController: UIViewController)
}

final class LaunchFilterRouterImpl: LaunchFilterRouter {
    func dismiss(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
