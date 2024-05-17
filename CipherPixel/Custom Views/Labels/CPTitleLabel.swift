//
//  CPTitleLabel.swift
//  CipherPixel
//
//  Created by serhat on 18.02.2024.
//

import UIKit

class CPTitleLabel: UILabel {


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment: NSTextAlignment, font: UIFont.TextStyle, weight: UIFont.Weight) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font          = UIFont.systemFont(ofSize: 20, weight: weight)
//        self.font          = UIFont.preferredFont(for: font, weight: weight)
        
        configure()
    }
    
    
    private func configure() {
        textColor                    = .label
//        font                         = .preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth    = true
        minimumScaleFactor           = 0.9
        lineBreakMode                = .byTruncatingTail
        numberOfLines                = 1
//        attributedText = NSAttributedString(string: "underline", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
