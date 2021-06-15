//
//  GalleryItemCell.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import UIKit

public class GalleryItemCell: UICollectionViewCell {
    public lazy var authorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public lazy var urlLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()
    }
    
    private func setupUI() {
        setupImageView()
        setupAuthorLabel()
        setupURLLabel()
    }
    
    private func setupAuthorLabel() {
        self.addSubview(authorLabel)
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
    }

    private func setupURLLabel() {
        self.addSubview(urlLabel)
    }
}
