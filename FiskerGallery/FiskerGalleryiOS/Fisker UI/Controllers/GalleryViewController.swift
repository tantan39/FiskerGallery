//
//  GalleryViewController.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import UIKit
import Combine

public class GalleryViewController: UICollectionViewController {
    public var viewModel: GalleryViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    public init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewFlowLayout(), viewModel: GalleryViewModel) {
        super.init(collectionViewLayout: layout)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundColor = .white
        self.collectionView.register(GalleryItemCell.self, forCellWithReuseIdentifier: "GalleryItemCell")
        
        self.viewModel?.fetchGallery()
        
        binding()
    }
    
    private func binding() {
        self.viewModel?.$items.sink(receiveValue: { [weak self] item in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }).store(in: &cancellables)
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryItemCell", for: indexPath) as? GalleryItemCell else { return UICollectionViewCell() }
        
        let item = self.viewModel?.items[indexPath.row]
        cell.authorLabel.text = item?.author
        cell.urlLabel.text = item?.url
        cell.backgroundColor = .yellow
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 10.0
        let column = 2.0
        let width: Double = ((Double(self.collectionView.bounds.width) - (padding * 3)) / column)
        return CGSize(width: width, height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
