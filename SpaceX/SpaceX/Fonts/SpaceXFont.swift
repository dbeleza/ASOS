//
//  SpaceXFont.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation
import UIKit

enum SpaceXFont: String {

    case black = "AvenirLTStd-Black"
    case heavy = "AvenirLTStd-Heavy"
    case book = "AvenirLTStd-Book"
    case light = "AvenirLTStd-Light"
    case medium = "AvenirLTStd-Medium"

    func of(size: Size) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size.rawValue) else {
            fatalError("Missing text font 💩")
        }
        return font
    }

    enum Size: CGFloat {
        case h1 = 27
        case h2 = 24
        case h3 = 22
        case extraBig = 20
        case big = 18
        case medium = 16
        case small = 14
        case extraSmall = 12
    }
}
