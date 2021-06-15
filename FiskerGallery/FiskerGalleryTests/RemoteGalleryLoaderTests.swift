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
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (GalleryLoader.Result) -> Void) {
        client.get(url: url, completion: { result in
            switch result {
            case .success: break
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}

class RemoteGalleryLoaderTests: XCTestCase {
    
    func test_init_withoutRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestUrls, [])
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT()
        sut.load(){ _ in }
        
        XCTAssertEqual(client.requestUrls, [url])
    }
    
    func test_loadTwice_requestDataFromURL_Twice() {
        let url = URL(string: "https://a-url.com")!
        let (sut, client) = makeSUT()
        
        sut.load(){ _ in }
        sut.load(){ _ in }
        
        XCTAssertEqual(client.requestUrls, [url, url])
    }
    
    func test_load_responseError() {
        let (sut, client) = makeSUT()
        
        let expect = expectation(description: "wait for load completion")
        let clientError = NSError(domain: "Test", code: 0)
        sut.load(completion: { result in
            switch result {
            case .success(_):
                break
            case let .failure(error):
                XCTAssertEqual(error as NSError, clientError)
            }
            
            expect.fulfill()
        })
        
        client.complete(with: clientError)
        
        wait(for: [expect], timeout: 1)
    }

    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteGalleryLoader, spy: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteGalleryLoader(url: url, client: client)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        
        var requestUrls: [URL] {
            return messages.map({ $0.url })
        }
        
        func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
}
