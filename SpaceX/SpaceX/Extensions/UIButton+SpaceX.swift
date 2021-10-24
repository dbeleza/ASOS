//
//  UIButton+SpaceX.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation
import UIKit

extension UIButton {
    static func primarySpaceXButton(title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.spaceDarkBlue
        let attrString = title.with(StringAttributes {
            $0.font = SpaceXFont.heavy.of(size: .small)
            $0.foregroundColor = UIColor.spaceWhite
        })
        button.setAttributedTitle(attrString, for: .normal)
        button.layer.cornerRadius = Constants.UI.baseline * 2
        return button
    }

    static func secondarySpaceXButton(title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.spaceGray
        let attrString = title.with(StringAttributes {
            $0.font = SpaceXFont.book.of(size: .small)
            $0.foregroundColor = UIColor.spaceWhite
        })
        button.setAttributedTitle(attrString, for: .normal)
        button.layer.cornerRadius = Constants.UI.baseline * 2
        return button
    }
}
