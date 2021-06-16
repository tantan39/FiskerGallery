//
//  GalleryViewController+TestsHelper.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import FiskerGallery
import UIKit

extension GalleryViewController {
    private var gallerySection: Int {
        return 0
    }
    
    func numberOfRenderedGalleryImageViews() -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    func galleryImageView(at row: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let indexPath = IndexPath(row: row, section: gallerySection)
        return ds?.collectionView(collectionView, cellForItemAt: indexPath)
    }
}
