//
//  UploadViewController.swift
//  NapWorkAssignment
//
//  Created by ISDP on 07/08/25.
//

import UIKit
import PhotosUI

class UploadViewController: UIViewController {
    
    @IBOutlet weak var browseGalleryButton: UIButton!
    @IBOutlet weak var openCamerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        browseGalleryButton.layer.borderWidth = 1
        browseGalleryButton.layer.borderColor = UIColor.systemGreen.cgColor
        browseGalleryButton.layer.cornerRadius = 8
        
        openCamerButton.layer.borderWidth = 1
        openCamerButton.layer.borderColor = UIColor.systemGreen.cgColor
        openCamerButton.layer.cornerRadius = 8
    }

    @IBAction func browseGalleryButtonTapped(_ sender: Any) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func openCamerButtonTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }
    
    private func presentImageDetailViewController(with image: UIImage) {
        let detailVC = ImageDetailViewController.instantiate(with: image)
        let nav = UINavigationController(rootViewController: detailVC)
        nav.modalPresentationStyle = .automatic
        
        present(nav, animated: true)
    }
}

extension UploadViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.presentImageDetailViewController(with: image)
                }
            }
        }
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            presentImageDetailViewController(with: image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
