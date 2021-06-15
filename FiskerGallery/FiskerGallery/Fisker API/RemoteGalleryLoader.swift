//
//  RemoteGalleryLoader.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

public class RemoteGalleryLoader: GalleryLoader {
    let url: URL
    let client: HTTPClient
    
    public init(url: URL, client: HTTPClient = URLSessionHTTPClient()) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectionError
        case invalidData
    }
    
    public func load(completion: @escaping (GalleryLoader.Result) -> Void) {
        client.get(url: url, completion: { result in
            switch result {
            case let .success((data, response)):
                completion(RemoteGalleryLoader.map(data, from: response))
                
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> GalleryLoader.Result {
        do {
            let items = try GalleryItemsMapper.map(data, response: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }

}

private extension Array where Element == RemoteGalleryItem {
    func toModels() -> [GalleryItem] {
        return map({ GalleryItem(id: UUID(uuidString: $0.id) ?? .init(), author: $0.author, url: $0.url) })
    }
}
