//
//  UIFont+Ext.swift
//  CipherPixel
//
//  Created by serhat on 20.02.2024.
//

import UIKit

//let label = UILabel()
//label.font = UIFont.preferredFont(for: .title1, weight: .bold)
//label.adjustsFontForContentSizeCategory = true
extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
