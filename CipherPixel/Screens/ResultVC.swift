//
//  ResultVC.swift
//  CipherPixel
//
//  Created by serhat on 18.02.2024.
//

import UIKit
import Photos
import PhotosUI

class ResultVC: UIViewController {
    
    var completionHandler: ((Bool, Error?) -> Void)?

    let resultTitle     = CPTitleLabel(textAlignment: .left, font: .title3, weight: .semibold)
    let imageView       = CPImagePicker(frame: .zero)
//    let noteForImage    = CPFootnoteLabel(textAlignment: .center)
    let noteForImage    = CPCalloutLabel(textAlignment: .center)
    let textField       = CPTextField(frame: .zero)
    let saveButton      = CPButton(backgroundColor: .systemPurple.withAlphaComponent(0.95), title: "Save the photo", systemImageName: "photo")
    let copyButton      = CPButton(backgroundColor: .systemCyan.withAlphaComponent(0.95), title: "Copy All", systemImageName: "doc.on.doc.fill")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createImageView()
        createNoteForImage()
        createTextField()
        createResultTitle()
        createSaveButton()
        createCopyButton()
        createKeyboardDismissButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .systemGreen
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        imageView.clear()
        textField.text = ""
    }


    private func configure(){
        view.backgroundColor = .systemBackground
    }
    
    
    func createImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    
    func createNoteForImage() {
        noteForImage.numberOfLines = 4
        noteForImage.text = "Caution:  When sending a Ciphered Image using messaging applications, it must be sent as a Document."
        view.addSubview(noteForImage)
        NSLayoutConstraint.activate([
            noteForImage.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            noteForImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteForImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteForImage.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    
    func createTextField() {
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    
    func createResultTitle() {
        view.addSubview(resultTitle)
        NSLayoutConstraint.activate([
            resultTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -180),
            resultTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    func createSaveButton() {
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func createCopyButton() {
        view.addSubview(copyButton)
        copyButton.addTarget(self, action: #selector(copyAllButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            copyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            copyButton.heightAnchor.constraint(equalToConstant: 44),
            copyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            copyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func createDismissKeyboardTapGesture() {
        let tapped = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapped)
    }
        
    
    func setResultImage(stegoImage: UIImage) {
        resultTitle.text      = "Ciphered Image"
        textField.isHidden    = true
        saveButton.isHidden   = false
        copyButton.isHidden   = true
        noteForImage.isHidden = false
        imageView.set(image: stegoImage)
    }
    
    
    func setResultMessage(secretMessage: String) {
        resultTitle.text      = "Secret Message"
        imageView.isHidden    = true
        textField.text        = secretMessage
        saveButton.isHidden   = true
        copyButton.isHidden   = false
        noteForImage.isHidden = true
        createDismissKeyboardTapGesture()
    }
    
    
    func createKeyboardDismissButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let keyboardIcon = UIImage(systemName: "keyboard.chevron.compact.down.fill")
        let keyboardButton = UIBarButtonItem(image: keyboardIcon, style: .plain, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [flexibleSpace, keyboardButton]
        self.textField.inputAccessoryView = toolbar
    }
       
    
    @objc func doneButtonTapped() {
        self.textField.resignFirstResponder()
    }
    
    
    @objc func copyAllButtonTapped() {
        UIPasteboard.general.string = self.textField.text
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.square.fill")
        
        let fullString = NSMutableAttributedString(string: "Copied ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        
        let alertController = UIAlertController(title: nil, message: "Secret Message has been copied.", preferredStyle: .alert)
        alertController.setValue(fullString, forKey: "attributedTitle")
        
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.modalPresentationStyle = .automatic
        present(alertController, animated: true)
    }
}


extension ResultVC {
    
    func saveToPhotoLibrary() {
        
        showLoadingView(state: .savePhoto) {
            let imageData = self.imageView.image.image!.pngData()
            let compressedImage = UIImage(data: imageData!)
    //        UIImageWriteToSavedPhotosAlbum(compressedImage!, self, #selector(savedUIAlert), nil)

            self.saveImageToPhotoAlbum(image: compressedImage!) { success, error in
                if success {
                    self.dismissLoadingView()
                    self.savedUIAlert()
                } else {
                    if let error = error {
                        self.dismissLoadingView()
                        print("Resim kaydetme hatası: \(error.localizedDescription)")
                        // Hata durumunda burada yapılacak işlemleri ekleyin
                        
                    }
                }
            }
        }
        
        
    }
    
    // Declare completionHandler property
    func saveImageToPhotoAlbum(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        // Handle completion in selector method
        self.completionHandler = completion
    }

    // Selector method to handle completion
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle error
            print("Error saving image: \(error.localizedDescription)")
            self.completionHandler?(false, error)
        } else {
            // Handle success
            print("Image saved successfully.")
            self.completionHandler?(true, nil)
        }
    }
    
    
    @objc func savedUIAlert() {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.square.fill")  //"plus.square.fill")
        
        let fullString = NSMutableAttributedString(string: "Cipher image saved ")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        
        let alertController = UIAlertController(title: nil, message: "Caution:  When sending a Ciphered Image using messaging applications, it must be sent as a Document.", preferredStyle: .alert)
        alertController.setValue(fullString, forKey: "attributedTitle")
        
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.modalPresentationStyle = .automatic
        present(alertController, animated: true)
    }
    
}


extension ResultVC : UIDocumentPickerDelegate {
    
        func handleDocumentPickerTapped() {
            view.endEditing(true)
      
            guard let image = self.imageView.image.image else {
                return
            }
    
            guard let imageURL = saveImageToDocumentsDirectory(image: image) else {
                print("Failed to save image to documents directory.")
                return
            }
    
            let documentPicker = UIDocumentPickerViewController(forExporting: [imageURL])
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true, completion: nil)

        }
        
        // Document Image Save
        func saveImageToDocumentsDirectory(image: UIImage) -> URL? {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Documents directory not found")
                return nil
            }
            
            let fileURL = documentsDirectory.appendingPathComponent("CipherPixelImage.png")
            
            do {
                if let imageData = image.pngData() {
                    try imageData.write(to: fileURL)
                    return fileURL
                } else {
                    print("Failed to convert image to PNG data")
                    return nil
                }
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
            
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            controller.dismiss(animated: true)
        }
    }


extension ResultVC {
    @objc func showAlert(_ sender: UIButton) {
        
        // Create a mutable attributed string
        let attributedTitle = NSMutableAttributedString(string: "Save photo to")
//        attributedTitle.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(for: .headline, weight: .bold), range: NSRange(location: 0, length: attributedTitle.length))

        // Create the alert controller with the attributed title
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")

        let action1 = UIAlertAction(title: "Photo Gallery", style: .default) { (action:UIAlertAction) in
            self.saveToPhotoLibrary()
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
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = sender.bounds
            popoverPresentationController.permittedArrowDirections = [.up, .down]
        }
        
        present(alertController, animated: true, completion: nil)
    }

}


/*
 Upcoming Feature:

 In the next version, Cipher Pixel will encrypt the secret message first before hiding it within the image using steganography. This means it will combine cryptography with steganography for enhanced security.
 */
