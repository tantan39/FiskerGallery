//
//  GalleryViewControllerTests.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import XCTest
import FiskerGallery

extension GalleryItemCell {
    var authorText: String {
        return authorLabel.text ?? ""
    }
    
    var urlText: String {
        return urlLabel.text ?? ""
    }
}

extension GalleryViewController {
    private var gallerySection: Int {
        return 0
    }
    
    func numberOfRenderedGalleryImageViews() -> Int {
        return collectionView.numberOfItems(inSection: gallerySection)
    }
    
    func galleryImageView(at row: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let indexPath = IndexPath(row: row, section: gallerySection)
        return ds?.collectionView(collectionView, cellForItemAt: indexPath)
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
    
    func test_loadGalleryCompletion_rendersSuccessfullyLoadedGallery() {
        let image0 = makeItem(author: "a author")
        let image1 = makeItem(author: "another author")

        let loader = LoaderSpy()
        let sut = GalleryViewController(viewModel: GalleryViewModel(loader: loader))
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeGalleryLoading(with: [image0, image1], at: 0)
        assertThat(sut, isRendering: [image0, image1])
    
    }
    
    // MARK: - Helpers
    func makeItem(author: String, url: URL = URL(string: "http://any-url.com")!) -> GalleryItem {
        return GalleryItem(id: UUID(), author: author, url: url)
    }
    
    func assertThat(_ sut: GalleryViewController, isRendering gallery: [GalleryItem], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedGalleryImageViews() == gallery.count else {
            return XCTFail("Expected \(gallery.count) images, got \(sut.numberOfRenderedGalleryImageViews()) instead.", file: file, line: line)
        }
        
        gallery.enumerated().forEach({ index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index)
        })
    }
    
    func assertThat(_ sut: GalleryViewController, hasViewConfiguredFor item: GalleryItem, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.galleryImageView(at: index)
        
        guard let cell = view as? GalleryItemCell else {
            return XCTFail("Expected \(GalleryItemCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
                
        XCTAssertEqual(cell.authorText, item.author, "Expected location text to be \(String(describing: item.author)) for image  view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.urlText, item.url.absoluteString, "Expected location text to be \(String(describing: item.url)) for image  view at index (\(index))", file: file, line: line)
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
        
        func completeGalleryLoading(with feed: [GalleryItem] = [],at index: Int = 0) {
            requests[index](.success(feed))
        }
    }
}
