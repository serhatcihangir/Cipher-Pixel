//
//  ViewController.swift
//  CipherPixel
//
//  Created by serhat on 15.02.2024.
//

import UIKit
import Photos
import PhotosUI

class HideVC: UIViewController {
        
    let imagePicker         = CPImagePicker(frame: .zero)
    let messageTextField    = CPTextField(frame: .zero)
    let coverImageTitle     = CPTitleLabel(textAlignment: .left, font: .title3, weight: .semibold)
    let secretMessageTitle  = CPTitleLabel(textAlignment: .left, font: .title3, weight: .semibold)
    let hideButton          = CPButton(backgroundColor: .systemGreen, title: "Hide Message", systemImageName: "eye.slash.fill")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createSecretMessageTitle()
        createMessageTextField()
        createKeyboardDismissButton()
        createCoverImageTitle()
        createImagePicker()
        createHideButton()
        createTappedImagePicker()
        createDismissKeyboardTapGesture()
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
    

    func createSecretMessageTitle() {
        secretMessageTitle.text = "Secret Message"
        view.addSubview(secretMessageTitle)
        NSLayoutConstraint.activate([
            secretMessageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            secretMessageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secretMessageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            secretMessageTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    

    func createMessageTextField(){
        view.addSubview(messageTextField)
        NSLayoutConstraint.activate([
            messageTextField.topAnchor.constraint(equalTo: secretMessageTitle.bottomAnchor, constant: 10),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            messageTextField.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    
    func createKeyboardDismissButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let keyboardIcon = UIImage(systemName: "keyboard.chevron.compact.down.fill")
        let keyboardButton = UIBarButtonItem(image: keyboardIcon, style: .plain, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, keyboardButton]
        messageTextField.inputAccessoryView = toolbar
    }
    
    
    @objc func doneButtonTapped() {
        messageTextField.resignFirstResponder()
    }
    

    func createCoverImageTitle() {
        coverImageTitle.text = "Cover Image"
        view.addSubview(coverImageTitle)
        NSLayoutConstraint.activate([
            coverImageTitle.topAnchor.constraint(equalTo: messageTextField.bottomAnchor, constant: 20),
            coverImageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            coverImageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            coverImageTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    

    func createImagePicker(){
        view.addSubview(imagePicker)
        NSLayoutConstraint.activate([
            imagePicker.topAnchor.constraint(equalTo:coverImageTitle.bottomAnchor , constant: 10),
            imagePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imagePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imagePicker.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func createHideButton() {
        view.addSubview(hideButton)
        hideButton.addTarget(self, action: #selector(pushCoveredImageVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            hideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            hideButton.heightAnchor.constraint(equalToConstant: 44),
            hideButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            hideButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc func pushCoveredImageVC() {
        
        guard !imagePicker.image.isHidden else {
            showImagePickerAlert(title: "Please select an image.")
            return
        }

        guard !messageTextField.text.isEmpty else {
            showImagePickerAlert(title: "Please write a secret message.")
            return
        }

        showLoadingView(state: .hiding) {
            var secretMessage = self.messageTextField.text!
            if let stegoImage = self.imagePicker.image.modifyLastBit(embed: &secretMessage) {
                let resultVC = ResultVC()
                resultVC.setResultImage(stegoImage: stegoImage)
                self.clear()
                self.dismissLoadingView()
                self.navigationController?.pushViewController(resultVC, animated: true)
            } else {
                if self.imagePicker.image.sizeErrorFlag {
                    self.showImagePickerAlert(title: "The size of the secret message is too long.")
                }else{
                    self.showImagePickerAlert(title: "Image format problem. Change the cover image.")
                }
                self.dismissLoadingView()
            }
        }

    }
    
    
    func createTappedImagePicker() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(showAlert(_:)))
        imagePicker.addGestureRecognizer(tapped)
    }
    

    func createDismissKeyboardTapGesture() {
        let tapped = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapped)
    }
    
    
    func clear() {
        imagePicker.clear()
        messageTextField.text = ""
    }

}


extension HideVC: UIDocumentPickerDelegate {
    
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


extension HideVC: PHPickerViewControllerDelegate {
    
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




extension HideVC {
    
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

    func showImagePickerAlert(title: String) {
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

//
//@available(iOS 17.0, *)
//#Preview {
//    let controller = HideVC()
//    return controller
//}
//
