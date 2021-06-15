//
//  GalleryViewControllerTests.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import XCTest
import FiskerGallery
import Combine

class GalleryItemCell: UICollectionViewCell {
    public let authorLabel = UILabel()
    public let imageView = UIImageView()
    public let urlLabel = UILabel()
}

extension GalleryItemCell {
    var authorText: String {
        return authorLabel.text ?? ""
    }
    
    var urlText: String {
        return urlLabel.text ?? ""
    }
}

class GalleryViewModel {
    private(set) var loader: GalleryLoader?
    
    @Published var items = [GalleryItem]()

    init(loader: GalleryLoader) {
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

class GalleryViewController: UICollectionViewController {
    var viewModel: GalleryViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewLayout(), viewModel: GalleryViewModel) {
        super.init(collectionViewLayout: layout)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.viewModel?.fetchGallery()
        
        self.viewModel?.$items.sink(receiveValue: { [weak self] item in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }).store(in: &cancellables)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.viewModel?.items[indexPath.row]
        let cell = GalleryItemCell()
        cell.authorLabel.text = item?.author
        cell.urlLabel.text = item?.url.absoluteString
        return cell
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

        let gallery = [image0, image1]
        let loader = LoaderSpy()
        let sut = GalleryViewController(viewModel: GalleryViewModel(loader: loader))
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeGalleryLoading(with: [image0, image1], at: 0)
        assertThat(sut, isRendering: [image0, image1])
        
        gallery.enumerated().forEach({ index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index)
        })
    }
    
    // MARK: - Helpers
    func makeItem(author: String, url: URL = URL(string: "http://any-url.com")!) -> GalleryItem {
        return GalleryItem(id: UUID(), author: author, url: url)
    }
    
    func assertThat(_ sut: GalleryViewController, isRendering feed: [GalleryItem], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedGalleryImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedGalleryImageViews()) instead.", file: file, line: line)
        }
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
