//
//  DetailsViewController.swift
//  FiskerGalleryiOS
//
//  Created by Tan Tan on 6/16/21.
//

import UIKit
import Combine
class DetailsViewController: UIViewController {
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
    
    private var viewModel: GalleryViewModel?
    private var cancellables = Set<AnyCancellable>()
    convenience init(viewModel: GalleryViewModel?) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        binding()
    }
    
    private func binding() {
        
    }
    
    private func setupUI() {
        setupImageView()
        setupURLLabel()
    }
    
    private func setupAuthorLabel() {
        self.view.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupImageView() {
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
        }
    }

    private func setupURLLabel() {
        self.view.addSubview(urlLabel)
        urlLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }
    }
}
