//
//  CPButton.swift
//  CipherPixel
//
//  Created by serhat on 18.02.2024.
//

import UIKit

class CPButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(backgroundColor: UIColor, title: String, systemImageName: String) {
        self.init(frame: .zero)
        set(color: backgroundColor, title: title, systemImageName: systemImageName)
    }
    
    
    private func configure() {
        
        configuration               = .filled()
        configuration?.cornerStyle  = .large
//        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    final func set(color: UIColor, title: String, systemImageName: String) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = .white
        configuration?.title               = title
        
        configuration?.image               = UIImage(systemName: systemImageName )
        configuration?.imagePadding        = 6
        configuration?.imagePlacement      = .leading
    }
}
