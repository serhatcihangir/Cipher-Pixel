//
//  UIViewController+Ext.swift
//  CipherPixel
//
//  Created by serhat on 1.03.2024.
//

import UIKit

fileprivate var containerView: UIView!
fileprivate var waitingBodyLabel: CPBodyLabel!
fileprivate var waitingFootnoteLabel: CPFootnoteLabel!

extension UIViewController {
   
    enum LoadingState {
        case hiding
        case revealing
        case savePhoto
        
        var bodyLabelText: String {
            switch self {
            case .hiding:
                return "Hiding secret message..."
            case .revealing:
                return "Getting secret message..."
            case .savePhoto:
                return "Saving photo to galery..."
            }
        }
        
        var footnoteLabelText: String {
            switch self {
            case .hiding:
                return "If the cover image is in high resolution, it may take more time. Please wait."
            case .revealing:
                return "If the cipher image is in high resolution, it may take more time. Please wait."
            case .savePhoto:
                return "If the cipher image is in high resolution, it may take more time. Please wait."
            }
        }
    }
    
    func showLoadingView(state: LoadingState, completion: @escaping () -> Void) {

        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        waitingBodyLabel = CPBodyLabel(textAlignment: .center)
        waitingBodyLabel.text = state.bodyLabelText
        waitingBodyLabel.textColor = .label.withAlphaComponent(0.9)
        containerView.addSubview(waitingBodyLabel)
        
        waitingFootnoteLabel = CPFootnoteLabel(textAlignment: .center)
        waitingFootnoteLabel.text = state.footnoteLabelText
        waitingFootnoteLabel.textColor = .label.withAlphaComponent(0.75)
        containerView.addSubview(waitingFootnoteLabel)
        
        
        containerView.backgroundColor    = .secondarySystemBackground //.systemBackground
        containerView.alpha              = 0.0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.93
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .label
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            waitingBodyLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 15),
            waitingBodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            waitingBodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            waitingBodyLabel.heightAnchor.constraint(equalToConstant: 20)
        ])       
        
        NSLayoutConstraint.activate([
            waitingFootnoteLabel.topAnchor.constraint(equalTo: waitingBodyLabel.bottomAnchor, constant: 5),
            waitingFootnoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            waitingFootnoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            waitingFootnoteLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            completion()
        }
        
    }
    
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView        = nil
            waitingBodyLabel     = nil
            waitingFootnoteLabel = nil
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
    }
        
}
