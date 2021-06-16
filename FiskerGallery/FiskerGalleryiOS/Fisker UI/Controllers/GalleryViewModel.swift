//
//  GalleryViewModel.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation
import Combine
import FiskerGallery

public protocol GalleryImageDataLoaderTask {
    func cancel()
}

public protocol GalleryImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> GalleryImageDataLoaderTask
}

public class GalleryViewModel {
    private(set) var loader: GalleryLoader?
    
    @Published public var items = [GalleryItem]()

    public init(loader: GalleryLoader) {
        self.loader = loader
    }
    
    func fetchGallery() {
        self.loader?.load(completion: { [weak self] result in
            guard let self = self else { return }
            if let items = try? result.get() {
                self.items = items
            }
        })
    }
}
