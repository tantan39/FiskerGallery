//
//  GalleryViewController.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import UIKit
import Combine

public class GalleryViewController: UICollectionViewController {
    var viewModel: GalleryViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    public init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewLayout(), viewModel: GalleryViewModel) {
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
        
        self.viewModel?.$items.sink(receiveValue: { [weak self] item in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).store(in: &cancellables)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryItemCell", for: indexPath) as? GalleryItemCell else { return UICollectionViewCell() }
        
        let item = self.viewModel?.items[indexPath.row]
        cell.authorLabel.text = item?.author
        cell.urlLabel.text = item?.url
        return cell
    }
}
