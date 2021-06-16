//
//  GalleryItemCell.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import UIKit
import SnapKit
import FiskerGallery
import Combine

public class GalleryItemCell: UICollectionViewCell {
    public lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()
    
    public lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    @Published public var viewModel: GalleryItemCelModel?
    private var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        setupUI()        
    }
    
    private func setupUI() {
        setupImageView()
        setupAuthorLabel()
        setupURLLabel()
        
        bindind()
    }
    
    private func bindind() {
        self.$viewModel.sink(receiveValue: { [weak self] viewModel in
            guard let self = self, let vm = viewModel else { return }

            vm.$author.assign(to: \.text, on: self.authorLabel)
                .store(in: &self.cancellables)
            vm.$url.assign(to: \.text, on: self.urlLabel)
                .store(in: &self.cancellables)
            vm.$image.assign(to: \.image, on: self.imageView)
                .store(in: &self.cancellables)
        }).store(in: &cancellables)
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.width.equalToSuperview()
            make.height.equalTo(self.snp.width)
        }
    }
    
    private func setupAuthorLabel() {
        self.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }

    private func setupURLLabel() {
        self.addSubview(urlLabel)
        urlLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(authorLabel.snp.top)
        }
    }
}
