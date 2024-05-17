//
//  RevealVC.swift
//  CipherPixel
//
//  Created by serhat on 16.02.2024.
//

import UIKit
import Photos
import PhotosUI

class RevealVC: UIViewController {

    let cipherImageTitle        = CPTitleLabel(textAlignment: .left, font: .title3, weight: .semibold)
    let imagePicker             = CPImagePicker(isRevealVC: true)
    let getSecretMessageButton  = CPButton(backgroundColor: .systemGreen, title: "Get Message", systemImageName: "eye.fill")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createCipherImageTitle()
        createImagePicker()
        createGetSecretMessageButton()
        createTappedImagePicker()
    }


    func configure(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22, weight: .semibold)]
//        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(for: .title2, weight: .semibold)]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.clear()
    }
    
    
    func createCipherImageTitle() {
        cipherImageTitle.text = "Cipher Image"
        view.addSubview(cipherImageTitle)
        NSLayoutConstraint.activate([
            cipherImageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            cipherImageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cipherImageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cipherImageTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    func createImagePicker(){
        view.addSubview(imagePicker)
        NSLayoutConstraint.activate([
            imagePicker.topAnchor.constraint(equalTo: cipherImageTitle.bottomAnchor, constant: 10),
            imagePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imagePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imagePicker.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func createGetSecretMessageButton() {
        view.addSubview(getSecretMessageButton)
        getSecretMessageButton.addTarget(self, action: #selector(pushSecretMessageVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            getSecretMessageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            getSecretMessageButton.heightAnchor.constraint(equalToConstant: 44),
            getSecretMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            getSecretMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
     
    
    @objc func pushSecretMessageVC() {
        guard !self.imagePicker.image.isHidden else {
            showImagePickerAlert(title: "Please select an image.")
            return
        }
        
        showLoadingView(state: .revealing) {
            // Get hidden message
            guard let hiddenMessage = self.imagePicker.image.getHiddenMessage() else {
                self.dismissLoadingView()
//                if !self.imagePicker.image.canDecode {  self.showImagePickerAlert(title: "Hidden message not found.")   }
                self.showImagePickerAlert(title: "Hidden message not found.")
                return
            }
            
            let resultVC = ResultVC()
            resultVC.setResultMessage(secretMessage: hiddenMessage)
            self.dismissLoadingView()
            self.clear()
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    
    func createTappedImagePicker() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(showAlert(_:)))
        imagePicker.addGestureRecognizer(tapped)
    }
       
    private func clear() {
        imagePicker.clear()
    }

}

extension RevealVC: UIDocumentPickerDelegate {
    
    func handleDocumentPickerTapped() {
        view.endEditing(true)
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        picker.delegate = self
        picker.allowsMultipleSelection = false
        picker.shouldShowFileExtensions = true
        present(picker, animated: true, completion: nil)
        
    }
    
     
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        guard let url = urls.first else { return }
        let shouldStopAccessing = url.startAccessingSecurityScopedResource()
        defer { if shouldStopAccessing {  url.stopAccessingSecurityScopedResource() } }
        
        do {
            let imageData = try Data(contentsOf: url)
            let selectedImage = UIImage(data: imageData)
            DispatchQueue.main.async { self.imagePicker.set(image: selectedImage!) }
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
        
        controller.dismiss(animated: true)
    }
        
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
}




extension RevealVC: PHPickerViewControllerDelegate {
    
        func handleImagePickerTapped(){
            view.endEditing(true)
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.selectionLimit = 1
            configuration.filter = PHPickerFilter.any(of: [.images])
            let vc = PHPickerViewController(configuration: configuration)
            vc.delegate = self
            present(vc, animated: true)
        }
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let result = results.first else { return }
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                    return
                }
                guard let image = reading as? UIImage else {
                    print("Failed to load image from provider")
                    return
                }
                DispatchQueue.main.async { [weak self] in self?.imagePicker.set(image: image) }
            }
        }
    
}


extension RevealVC {
    
    @objc func showAlert(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        
        // Create a mutable attributed string
        let attributedTitle = NSMutableAttributedString(string: "Select photo from")
//        attributedTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(for: .headline, weight: .semibold), range: NSRange(location: 0, length: attributedTitle.length))
                
        // Create the alert controller with the attributed title
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")

        let action1 = UIAlertAction(title: "Photo Gallery", style: .default) { (action:UIAlertAction) in
            self.handleImagePickerTapped()
        }
        alertController.addAction(action1)
        
        let action2 = UIAlertAction(title: "Files", style: .default) { (action:UIAlertAction) in
            self.handleDocumentPickerTapped()
        }
        alertController.addAction(action2)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.modalPresentationStyle = .popover
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = view.bounds
            popoverPresentationController.permittedArrowDirections = [.up, .down]
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func showImagePickerAlert(title: String) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "x.square.fill")
        
        let fullString = NSMutableAttributedString(string: "Failure ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        alertController.setValue(fullString, forKey: "attributedTitle")
        
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.modalPresentationStyle = .automatic
        present(alertController, animated: true)
    }

}
