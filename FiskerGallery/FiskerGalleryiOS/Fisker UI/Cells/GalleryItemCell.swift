//
//  GalleryItemCell.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import UIKit
import SnapKit

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
    
    private func setupImageView() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAuthorLabel() {
        self.addSubview(authorLabel)
    }

    private func setupURLLabel() {
        self.addSubview(urlLabel)
    }
    
    func configCell(item: GalleryItem?) {
        guard let item = item else { return }
        self.authorLabel.text = item.author
        self.urlLabel.text = item.url
        DispatchQueue.global().async {
            if let url = URL(string: item.url), let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    
                    self.imageView.image = image
                }
            }
        }
        
    }
}
