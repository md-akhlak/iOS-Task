//
//  UploadViewController.swift
//  NapWorkAssignment
//
//  Created by ISDP on 07/08/25.
//

import UIKit
import PhotosUI

class UploadViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageContainerView = UIView()
    private let imageView = UIImageView()
    private let placeholderStackView = UIStackView()
    private let placeholderImageView = UIImageView()
    private let placeholderLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let galleryButton = UIButton(type: .system)
    private let cameraButton = UIButton(type: .system)
    private let formContainerView = UIView()
    private let referenceNameTextField = UITextField()
    private let submitButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        // Modern navigation bar styling
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Upload Image"
        
        // Add a cancel button if presented modally
        if presentingViewController != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(cancelTapped)
            )
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        setupScrollView()
        setupImageContainer()
        setupButtons()
        setupForm()
        setupSubmitButton()
        setupActivityIndicator()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    private func setupImageContainer() {
        // Container view with modern card-like appearance
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.backgroundColor = UIColor.systemBackground
        imageContainerView.layer.cornerRadius = 16
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageContainerView.layer.shadowRadius = 8
        imageContainerView.layer.shadowOpacity = 0.1
        contentView.addSubview(imageContainerView)
        
        // Image View
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageContainerView.addSubview(imageView)
        
        // Placeholder Stack View
        placeholderStackView.translatesAutoresizingMaskIntoConstraints = false
        placeholderStackView.axis = .vertical
        placeholderStackView.alignment = .center
        placeholderStackView.spacing = 12
        imageContainerView.addSubview(placeholderStackView)
        
        // Placeholder Image
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.image = UIImage(systemName: "photo.badge.plus")
        placeholderImageView.tintColor = UIColor.systemGray3
        placeholderImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 48, weight: .light)
        placeholderStackView.addArrangedSubview(placeholderImageView)
        
        // Placeholder Label
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "Add Photo"
        placeholderLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        placeholderLabel.textColor = UIColor.systemGray2
        placeholderStackView.addArrangedSubview(placeholderLabel)
    }
    
    private func setupButtons() {
        // Button Stack View
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        contentView.addSubview(buttonStackView)
        
        // Gallery Button - Modern iOS style
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        galleryButton.setTitle("Choose from Library", for: .normal)
        galleryButton.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        galleryButton.backgroundColor = UIColor.systemBackground
        galleryButton.setTitleColor(UIColor.systemBlue, for: .normal)
        galleryButton.tintColor = UIColor.systemBlue
        galleryButton.layer.cornerRadius = 12
        galleryButton.layer.shadowColor = UIColor.black.cgColor
        galleryButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        galleryButton.layer.shadowRadius = 4
        galleryButton.layer.shadowOpacity = 0.1
        galleryButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        galleryButton.contentHorizontalAlignment = .center
        galleryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        buttonStackView.addArrangedSubview(galleryButton)
        
        // Camera Button
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.setTitle("Take Photo", for: .normal)
        cameraButton.setImage(UIImage(systemName: "camera"), for: .normal)
        cameraButton.backgroundColor = UIColor.systemBackground
        cameraButton.setTitleColor(UIColor.systemBlue, for: .normal)
        cameraButton.tintColor = UIColor.systemBlue
        cameraButton.layer.cornerRadius = 12
        cameraButton.layer.shadowColor = UIColor.black.cgColor
        cameraButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        cameraButton.layer.shadowRadius = 4
        cameraButton.layer.shadowOpacity = 0.1
        cameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        cameraButton.contentHorizontalAlignment = .center
        cameraButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        buttonStackView.addArrangedSubview(cameraButton)
        
        // Add button press animations
        [galleryButton, cameraButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
    }
    
    private func setupForm() {
        // Form Container
        formContainerView.translatesAutoresizingMaskIntoConstraints = false
        formContainerView.backgroundColor = UIColor.systemBackground
        formContainerView.layer.cornerRadius = 16
        formContainerView.layer.shadowColor = UIColor.black.cgColor
        formContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        formContainerView.layer.shadowRadius = 8
        formContainerView.layer.shadowOpacity = 0.1
        contentView.addSubview(formContainerView)
        
        // Reference Name TextField
        referenceNameTextField.translatesAutoresizingMaskIntoConstraints = false
        referenceNameTextField.placeholder = "Reference Name"
        referenceNameTextField.font = UIFont.systemFont(ofSize: 17)
        referenceNameTextField.borderStyle = .none
        referenceNameTextField.backgroundColor = UIColor.clear
        referenceNameTextField.returnKeyType = .done
        referenceNameTextField.delegate = self
        formContainerView.addSubview(referenceNameTextField)
        
        // Add a subtle separator line
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.separator
        formContainerView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: referenceNameTextField.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: referenceNameTextField.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: referenceNameTextField.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupSubmitButton() {
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Upload Image", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .disabled)
        submitButton.backgroundColor = UIColor.systemBlue
        submitButton.layer.cornerRadius = 16
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        submitButton.layer.shadowColor = UIColor.systemBlue.cgColor
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        submitButton.layer.shadowRadius = 8
        submitButton.layer.shadowOpacity = 0.3
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitButtonTouchDown), for: .touchDown)
        submitButton.addTarget(self, action: #selector(submitButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        contentView.addSubview(submitButton)
        
        updateSubmitButton()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.systemBlue
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Image Container
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageContainerView.heightAnchor.constraint(equalToConstant: 280),
            
            // Image View
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -12),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -12),
            
            // Placeholder Stack View
            placeholderStackView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            
            // Button Stack View
            buttonStackView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 116), // 2 buttons * 52 height + 12 spacing
            
            // Individual button heights
            galleryButton.heightAnchor.constraint(equalToConstant: 52),
            cameraButton.heightAnchor.constraint(equalToConstant: 52),
            
            // Form Container
            formContainerView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 24),
            formContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            formContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            formContainerView.heightAnchor.constraint(equalToConstant: 56),
            
            // Reference Name TextField
            referenceNameTextField.topAnchor.constraint(equalTo: formContainerView.topAnchor, constant: 16),
            referenceNameTextField.leadingAnchor.constraint(equalTo: formContainerView.leadingAnchor, constant: 16),
            referenceNameTextField.trailingAnchor.constraint(equalTo: formContainerView.trailingAnchor, constant: -16),
            referenceNameTextField.bottomAnchor.constraint(equalTo: formContainerView.bottomAnchor, constant: -16),
            
            // Submit Button
            submitButton.topAnchor.constraint(equalTo: formContainerView.bottomAnchor, constant: 32),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 56),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func galleryButtonTapped() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func cameraButtonTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera Unavailable", message: "Camera is not available on this device")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func submitButtonTapped() {
        guard let image = selectedImage,
              let referenceName = referenceNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !referenceName.isEmpty else {
            showAlert(title: "Missing Information", message: "Please select an image and enter a reference name")
            return
        }
        
        startLoading()
        
        FirebaseService.shared.uploadImage(image, referenceName: referenceName) { [weak self] result in
            DispatchQueue.main.async {
                self?.stopLoading()
                
                switch result {
                case .success:
                    self?.showAlert(title: "Success", message: "Image uploaded successfully!") {
                        self?.resetForm()
                    }
                case .failure(let error):
                    self?.showAlert(title: "Upload Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Button Animation Methods
    @objc private func buttonTouchDown(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            button.alpha = 0.8
        }
    }
    
    @objc private func buttonTouchUp(_ button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.transform = .identity
            button.alpha = 1.0
        }
    }
    
    @objc private func submitButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.submitButton.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
    @objc private func submitButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.submitButton.transform = .identity
        }
    }
    
    // MARK: - Helper Methods
    private func updateImageView() {
        if selectedImage != nil {
            imageView.image = selectedImage
            imageView.isHidden = false
            placeholderStackView.isHidden = true
        } else {
            imageView.isHidden = true
            placeholderStackView.isHidden = false
        }
        updateSubmitButton()
    }
    
    private func updateSubmitButton() {
        let hasImage = selectedImage != nil
        let hasText = !(referenceNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isEnabled = hasImage && hasText
        
        submitButton.isEnabled = isEnabled
        submitButton.backgroundColor = isEnabled ? UIColor.systemBlue : UIColor.systemGray3
        submitButton.layer.shadowOpacity = isEnabled ? 0.3 : 0.1
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
        submitButton.isEnabled = false
        submitButton.setTitle("Uploading...", for: .normal)
        view.isUserInteractionEnabled = false
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
        submitButton.setTitle("Upload Image", for: .normal)
        view.isUserInteractionEnabled = true
        updateSubmitButton()
    }
    
    private func resetForm() {
        selectedImage = nil
        referenceNameTextField.text = ""
        updateImageView()
        
        // Add a nice reset animation
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension UploadViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    self?.selectedImage = image
                    self?.updateImageView()
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            updateImageView()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension UploadViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Update submit button state after text change
        DispatchQueue.main.async {
            self.updateSubmitButton()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
