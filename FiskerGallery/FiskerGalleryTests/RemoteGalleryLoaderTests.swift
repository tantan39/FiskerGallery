//
//  RemoteGalleryLoaderTests.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import XCTest

protocol GalleryLoader {
    typealias Result = Swift.Result<[GalleryItem], Error>
    
    func load(completion: @escaping (Result) -> Void)
}

struct GalleryItem {
    let id: UUID
    let author: String
    let url: URL
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(url: URL, completion: @escaping (Result) -> Void)
}

struct RemoteGalleryLoader: GalleryLoader {
    let url: URL
    let client: HTTPClient
    
    func load(completion: (GalleryLoader.Result) -> Void) {
        
    }
}

class RemoteGalleryLoaderTests: XCTestCase {
    
    func test_init_withoutRequest() {
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-url.com")!
        _ = RemoteGalleryLoader(url: url, client: client)
        
        XCTAssertEqual(client.requestUrls, [])
    }
    
    // MARK: - Helpers
    class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        
        var requestUrls: [URL] {
            return messages.map({ $0.url })
        }
        
        func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {

        }
    }
}
