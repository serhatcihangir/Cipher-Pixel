//
//  CPTextField.swift
//  CipherPixel
//
//  Created by serhat on 17.02.2024.
//

import UIKit

class CPTextField: UITextView{

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius          = 12
        layer.borderWidth           = 2.0
        layer.borderColor           = UIColor.systemGray4.cgColor
        
        textColor                   = .label
        tintColor                   = .label
        textAlignment               = .natural
        font                        = UIFont.preferredFont(forTextStyle: .callout)
//        adjustsFontSizeToFitWidth   = true
//        minimumFontSize             = 12
        
        backgroundColor             = .secondarySystemBackground
        autocorrectionType          = .default
        returnKeyType               = .next
        keyboardType                = .default
        
//        placeholder                 = "Enter a username"
//        backgroundColor             = .quaternarySystemFill
//        contentVerticalAlignment    = .top
//        defaultTextAttributes[.paragraphStyle]
    }
    
}
