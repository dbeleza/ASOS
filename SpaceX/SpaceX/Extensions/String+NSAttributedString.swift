//
//  StringAttributes.swift
//  SpaceX
//
//  Created by David Beleza on 24/10/2021.
//

import Foundation

extension String {
    func with(_ attributes: StringAttributes) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: attributes)
    }
}
