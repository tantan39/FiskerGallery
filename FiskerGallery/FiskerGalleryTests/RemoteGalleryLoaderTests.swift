//
//  RemoteGalleryLoaderTests.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import XCTest
import FiskerGallery

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    struct UnexpectedValueRepresentation: Error {
        
    }
    
    func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.dataTask(with: url) { data, response, error in
            completion( Result(catching: {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValueRepresentation()
                }
            }))
        }.resume()
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
    
    func test_load_responseErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let sample = [199, 201, 300, 400, 500]
        sample.enumerated().forEach({ index, code in
            expect(sut, toCompleteWith: .failure(RemoteGalleryLoader.Error.invalidData)) {
                let json = makeJSONItems([])
                client.complete(withStatusCode: code, data: json, at: index )
            }
        })
    }
    
    func test_load_responseErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteGalleryLoader.Error.invalidData)) {
            let data = "invalid json data".data(using: .utf8)!
            client.complete(withStatusCode: 200, data: data )
        }
    }
    
    func test_load_deliversListItemOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()
                
        let item1 = makeItem(id: UUID(), author: "author", url: URL(string: "https://a-url.com")!)
        
        let item2 = makeItem(id: UUID(), author: "another author", url: URL(string: "https://a-url.com")!)
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeJSONItems([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
        
    }

    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteGalleryLoader, spy: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteGalleryLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteGalleryLoader,
                        toCompleteWith expectedResult: RemoteGalleryLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #filePath, line: UInt = #line) {
        
        let expect = expectation(description: "wait for load completion")
        
        sut.load(completion: { receiveResult in
            switch (receiveResult, expectedResult) {
            case let (.success(receiveItems), .success(expectedItems)):
                XCTAssertEqual(receiveItems, expectedItems, file: file, line: line)
                
            case let (.failure(receiveError as RemoteGalleryLoader.Error), .failure(expectedError as RemoteGalleryLoader.Error)):
                XCTAssertEqual(receiveError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receiveResult) instead", file: file, line: line)
            }
            expect.fulfill()
        })
        
        action()
        wait(for: [expect], timeout: 1)
    }
    
    private func makeJSONItems(_ items: [[String : Any]]) -> Data {
        let json = ["array": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeItem(id: UUID, author: String, url: URL) -> (model: GalleryItem, json: [String: Any])  {
        let item = GalleryItem(id: id, author: author, url: url)
        let json = [ "id": item.id.description,
                          "author": item.author,
                          "url": item.url.absoluteString
        ]
        .compactMapValues({ $0 })
        
        return (item, json)
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
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestUrls[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }
}
