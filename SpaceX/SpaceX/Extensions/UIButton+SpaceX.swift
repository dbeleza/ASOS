//
//  UIButton+SpaceX.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation
import UIKit

extension UIButton {
    static func createSpaceXButton(title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.spaceDarkBlue
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = Constants.Margin.baseline * 2
        return button
    }
}
