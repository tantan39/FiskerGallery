//
//  GalleryViewController.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import UIKit
import Combine
import FiskerGallery
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
        self.navigationController?.navigationBar.isTranslucent = false
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

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryItemCell", for: indexPath) as? GalleryItemCell, let item = self.viewModel?.items[indexPath.row] else { return UICollectionViewCell() }
        cell.viewModel = GalleryItemCelModel(item: item)
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let _ = cell as? GalleryItemCell, let item = self.viewModel?.items[indexPath.row]  else { return }
    
        ImageDownloadManager.shared.downloadImage(item.imageDownloadURL, indexPath: indexPath) { (image, url, indexPathh, error) in
            if let indexPathNew = indexPathh {
                DispatchQueue.main.async {
                    if let getCell = collectionView.cellForItem(at: indexPathNew) as? GalleryItemCell {
                        getCell.viewModel?.setImage(image: image)
                    }
                }
            }
        }

    }
    
    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /* Reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
        guard let item = self.viewModel?.items[indexPath.row] else { return }
        ImageDownloadManager.shared.slowDownImageDownloadTaskfor(item)
    }
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.viewModel?.items[indexPath.row] else { return }
        self.viewModel?.selectedItem = item
        let detailsVC = DetailsViewController(viewModel: self.viewModel)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 20.0
        let column = 2.0
        let width: Double = ((Double(self.collectionView.bounds.width) - padding - 32) / column)
        return CGSize(width: width, height: width + 60)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
