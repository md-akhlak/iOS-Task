//
//  ImageCollectionViewCell.swift
//  NapWorkAssignment
//
//  Created by ISDP on 07/08/25.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var currentImageURL: String?
    private var imageLoadTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        activityIndicator.stopAnimating()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        currentImageURL = nil
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Configure imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        
        // Setup activity indicator
        if activityIndicator.superview == nil {
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.hidesWhenStopped = true
            contentView.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    }
    
    func configure(with imageModel: ImageModel) {
        nameLabel.text = imageModel.referenceName
        imageView.image = nil
        currentImageURL = imageModel.imageURL
        
        activityIndicator.startAnimating()
        
        // Check cache first
        if let cachedImage = ImageCache.shared.getImage(forKey: imageModel.imageURL) {
            imageView.image = cachedImage
            activityIndicator.stopAnimating()
            return
        }
        
        // Load image
        guard let url = URL(string: imageModel.imageURL) else {
            activityIndicator.stopAnimating()
            return
        }
        
        imageLoadTask?.cancel()
        
        imageLoadTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  self.currentImageURL == imageModel.imageURL,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
                return
            }
            
            ImageCache.shared.setImage(image, forKey: imageModel.imageURL)
            
            DispatchQueue.main.async {
                if self.currentImageURL == imageModel.imageURL {
                    self.imageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        imageLoadTask?.resume()
    }
}
