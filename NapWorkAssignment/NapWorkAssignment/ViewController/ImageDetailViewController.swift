//
//  ImageDetailViewController.swift
//  NapWorkAssignment
//
//  Created by ISDP on 07/08/25.



import UIKit
import FirebaseStorage
import FirebaseFirestore

class ImageDetailViewController: UIViewController {
    var selectedImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var referenceTypeTextField: UITextField!
    @IBOutlet weak var submitSutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        imageView.image = selectedImage
        imageView.contentMode = .scaleAspectFit
        
        submitSutton.layer.cornerRadius = 8
        submitSutton.backgroundColor = .systemGreen
        submitSutton.setTitleColor(.white, for: .normal)
        
        referenceTypeTextField.borderStyle = .roundedRect
        referenceTypeTextField.placeholder = "Enter reference type"
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    static func instantiate(with image: UIImage) -> ImageDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        controller.selectedImage = image
        return controller
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let image = selectedImage,
              let referenceType = referenceTypeTextField.text, !referenceType.isEmpty else {
            showAlert(message: "Please enter a reference type")
            return
        }
        
        let loadingAlert = UIAlertController(title: nil, message: "Uploading...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true)
        
        FirebaseService.shared.uploadImage(image, referenceName: referenceType) { [weak self] result in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    switch result {
                    case .success:
                        self?.showAlert(message: "Image uploaded successfully") {
                            self?.dismiss(animated: true)
                        }
                    case .failure(let error):
                        self?.showAlert(message: "Upload failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
