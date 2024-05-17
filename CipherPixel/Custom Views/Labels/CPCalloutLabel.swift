//
//  CPCalloutLabel.swift
//  CipherPixel
//
//  Created by serhat on 14.03.2024.
//

import UIKit

class CPCalloutLabel: UILabel {

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
    
    
    private func configure(){
        textColor            = .secondaryLabel
        font                 = .preferredFont(forTextStyle: .subheadline)
        numberOfLines        = 4
        lineBreakMode        = .byWordWrapping
        minimumScaleFactor   = 0.75
        translatesAutoresizingMaskIntoConstraints = false
    }

}
