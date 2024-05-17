//
//  CPImagePicker.swift
//  CipherPixel
//
//  Created by serhat on 17.02.2024.
//

import UIKit

class CPImagePicker: UIView {

    let placeholder     = CPImageView(frame: .zero)
    let bodyLabel       = CPBodyLabel(textAlignment: .center)
    let footnoteLabel   = CPFootnoteLabel(textAlignment: .center)
    var image           = CPImageView(frame: .zero)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        bodyLabel.text      = "Click to select an image"
        footnoteLabel.text  = "used to hide the secret message"
        configure()
        configureSubviews()
    }
    
    
    convenience init(isRevealVC: Bool) {
        self.init(frame: .zero)
        footnoteLabel.text = isRevealVC ? "used to get the secret message" : "used to hide the secret message"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    
    func clear(){
        placeholder.isHidden     = false
        bodyLabel.isHidden       = false
        footnoteLabel.isHidden   = false
        image.isHidden           = true
        image.image              = nil
    }
    
    func set(image: UIImage) {
        self.image.image = image
        self.image.isHidden      = false
        placeholder.isHidden     = true
        bodyLabel.isHidden       = true
        footnoteLabel.isHidden   = true
    }
    
    
    private func configure() {
        image.isHidden       = true
        backgroundColor      = .systemGreen.withAlphaComponent(0.17)
        layer.cornerRadius   = 12
        layer.borderWidth    = 2.0
        layer.borderColor    = backgroundColor?.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSubviews(){
        addSubview(placeholder)
        NSLayoutConstraint.activate([
            placeholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            placeholder.widthAnchor.constraint(equalTo: placeholder.heightAnchor),
            placeholder.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholder.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20)

        ])
        
        addSubview(bodyLabel)
        NSLayoutConstraint.activate([
            bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bodyLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        addSubview(footnoteLabel)
        NSLayoutConstraint.activate([
            footnoteLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            footnoteLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            footnoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            footnoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            footnoteLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        addSubview(image)
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),    //45
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            image.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])        

    }
    
}
