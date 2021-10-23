//
//  LaunchDetailsRouter.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
import UIKit

public protocol LaunchDetailsRouter {
    func openBrowser(url: URL)
}

final class LaunchDetailsRouterImpl: LaunchDetailsRouter {
    func openBrowser(url: URL) {
        UIApplication.shared.open(url)
    }
}
