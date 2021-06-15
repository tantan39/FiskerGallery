//
//  GalleryViewControllerTests.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import XCTest
import FiskerGallery

class GalleryViewModel {
    private(set) var loader: GalleryLoader?
    
    init(loader: GalleryLoader) {
        self.loader = loader
    }
    
    func fetchGallery() {
        self.loader?.load(completion: { _ in })
    }
}

class GalleryViewController: UICollectionViewController {
    var viewModel: GalleryViewModel?
    
    init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewLayout(), viewModel: GalleryViewModel) {
        super.init(collectionViewLayout: layout)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.viewModel?.fetchGallery()
    }
}

class GalleryViewControllerTests: XCTestCase {
    func test_loadGalleryActions_requestGalleryFromLoader() {
        let loader = LoaderSpy()
        let sut = GalleryViewController(viewModel: GalleryViewModel(loader: loader))
        
        XCTAssertEqual(loader.loadGalleryCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadGalleryCallCount, 1, "Expected a loading request once view is loaded")
    }
}

extension GalleryViewControllerTests {
    class LoaderSpy: GalleryLoader {
    
        private var requests = [(GalleryLoader.Result) -> Void]()
        
        var loadGalleryCallCount: Int {
            return requests.count
        }
        
        func load(completion: @escaping (GalleryLoader.Result) -> Void) {
            requests.append(completion)
        }
    }
}
