//
//  CPBodyLabel.swift
//  CipherPixel
//
//  Created by serhat on 17.02.2024.
//

import UIKit

class CPBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment: NSTextAlignment){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    
    private func configure() {
        textColor                    = .label
        font                         = .preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth    = true
        minimumScaleFactor           = 0.9
        lineBreakMode                = .byTruncatingTail
        numberOfLines                = 1
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
