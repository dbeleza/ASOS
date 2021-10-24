//
//  NSAttributedString+Builder.swift
//  SpaceX
//
//  Created by David Beleza on 24/10/2021.
//

import Foundation
import UIKit

typealias StringAttributes = [NSAttributedString.Key: Any]

extension StringAttributes {

    init(_ builder: (inout StringAttributes) -> Void) {
        self.init()
        builder(&self)
    }

    var font: UIFont? {
        get {
            return self[NSAttributedString.Key.font] as? UIFont
        }
        set {
            self[NSAttributedString.Key.font] = newValue
        }
    }

    var foregroundColor: UIColor? {
        get {
            return self[NSAttributedString.Key.foregroundColor] as? UIColor
        }
        set {
            self[NSAttributedString.Key.foregroundColor] = newValue
        }
    }
}
